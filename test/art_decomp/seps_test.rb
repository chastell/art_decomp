require_relative '../test_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/seps'

module ArtDecomp
  describe Seps do
    let(:sep_01)          { Seps.from_blocks([B[0], B[1]])             }
    let(:sep_01_02)       { Seps.from_blocks([B[0], B[1,2]])           }
    let(:sep_01_02_03_13) { Seps.from_blocks([B[0], B[1,2], B[2,3]])   }
    let(:sep_01_02_12)    { Seps.from_blocks([B[0], B[1], B[2]])       }
    let(:sep_01_12)       { Seps.from_blocks([B[0,2], B[1], B[2]])     }
    let(:sep_03_13)       { Seps.from_blocks([B[0,1,2], B[2,3]])       }
    let(:sep_12)          { Seps.from_blocks([B[0,1], B[0,2]])         }

    describe '.from_blocks' do
      it 'builds a proper matrix' do
        {
          []           => [],
          [B[0]]       => [],
          [B[0,1]]     => [],
          [B[0], B[1]] => [0b10, 0b01],
          [B[0], B[1], B[2,3], B[4]] => [
            0b11110,
            0b11101,
            0b10011,
            0b10011,
            0b01111,
          ],
          [B[1], B[4]] => [
            0b10010,
            0b11101,
            0b10010,
            0b10010,
            0b01111,
          ],
          [B[0,2,3], B[1], B[4]] => [
            0b10010,
            0b11101,
            0b10010,
            0b10010,
            0b01111,
          ],
          [B[0,1,2,3], B[0,2,3,4]] => [
            0b00000,
            0b10000,
            0b00000,
            0b00000,
            0b00010,
          ],
          [B[0], B[1], B[2], B[3], B[4]] => [
            0b11110,
            0b11101,
            0b11011,
            0b10111,
            0b01111,
          ],
          [B[0,1,2], B[1,2,3,4]] => [
            0b11000,
            0b00000,
            0b00000,
            0b00001,
            0b00001,
          ],
        }.each do |blocks, matrix|
          Seps.from_blocks(blocks).must_equal Seps.new(matrix)
        end
      end
    end

    describe '.from_column' do
      it 'builds a proper matrix' do
        {
          %i()    => [],
          %i(a)   => [],
          %i(a a) => [],
          %i(a b) => [0b10, 0b01],
          %i(a b c c d) => [
            0b11110,
            0b11101,
            0b10011,
            0b10011,
            0b01111,
          ],
          %i(a b a a c) => [
            0b10010,
            0b11101,
            0b10010,
            0b10010,
            0b01111,
          ],
          %i(- a - - b) => [
            0b00000,
            0b10000,
            0b00000,
            0b00000,
            0b00010,
          ],
          %i(a b c d e) => [
            0b11110,
            0b11101,
            0b11011,
            0b10111,
            0b01111,
          ],
          %i(a - - b b) => [
            0b11000,
            0b00000,
            0b00000,
            0b00001,
            0b00001,
          ],
        }.each do |column, matrix|
          Seps.from_column(column).must_equal Seps.new(matrix)
        end
      end
    end

    describe '.new' do
      it 'can take a matrix to start from' do
        Seps.new([B[2], B[], B[0]])
          .must_equal Seps.from_blocks([B[0,1], B[1,2]])
      end

      it 'normalises the matrix' do
        Seps.from_blocks([B[0,1,2]]).must_equal Seps.new([])
      end
    end

    describe '.normalise' do
      it 'normalises the matrix' do
        Seps.normalise([0b000, 0b000, 0b000]).must_equal []
        Seps.normalise([0b010, 0b001, 0b000]).must_equal [0b10, 0b01]
        Seps.normalise([0b000, 0b100, 0b000]).must_equal [0b000, 0b100, 0b000]
      end
    end

    describe '#&' do
      it 'returns the conjunction of the Seps' do
        (sep_01_02 & sep_01_12).must_equal sep_01
        (sep_01_02_03_13 & sep_01_02_12).must_equal sep_01_02
        (sep_01_02_12 & sep_01_02_03_13).must_equal sep_01_02
      end
    end

    describe '#-' do
      it 'returns the difference of the Seps' do
        (sep_01_02_03_13 - sep_01_02_12).must_equal sep_03_13
        (sep_01_02_12 - sep_01_02_03_13).must_equal sep_12
        (sep_03_13 - sep_03_13).must_be :empty?
      end
    end

    describe '#==' do
      it 'compares two Seps by value' do
        assert Seps.from_blocks([B[0,1], B[1,2]]) ==
          Seps.from_blocks([B[0,1], B[1,2]]).dup
        assert Seps.from_blocks([B[0,1], B[1,2]]) ==
          Seps.from_blocks([B[1,2], B[0,1]])
        refute Seps.from_blocks([B[0,1], B[1,2]]) ==
          Seps.from_blocks([B[0,2], B[1,2]])
      end
    end

    describe '#|' do
      it 'returns the disjunction of the Seps' do
        (sep_01_12 | sep_01_02).must_equal sep_01_02_12
        (sep_01_02 | sep_12).must_equal sep_01_02_12
        (sep_12 | sep_01_02).must_equal sep_01_02_12
      end
    end

    describe '#empty?' do
      it 'returns a predicate whether the Seps are empty' do
        Seps.from_blocks([]).must_be :empty?
        Seps.from_blocks([B[0,1]]).must_be :empty?
        Seps.from_blocks([B[0], B[1]]).wont_be :empty?
      end
    end

    describe '#inspect' do
      it 'returns a self-initialising representation' do
        Seps.from_blocks([]).inspect.must_equal 'ArtDecomp::Seps.new([])'
        Seps.new([B[2], B[], B[0]]).inspect
          .must_equal 'ArtDecomp::Seps.new([B[2], B[], B[0]])'
      end
    end

    describe '#size' do
      it 'returns the number of separations' do
        Seps.from_blocks([]).size.must_equal 0
        Seps.from_blocks([B[0], B[1]]).size.must_equal 1
        Seps.from_blocks([B[0,1,2], B[1,2,3,4]]).size.must_equal 2
        Seps.from_blocks([B[0,2,3], B[1], B[4]]).size.must_equal 7
        Seps.from_blocks([B[0,1,2,3], B[0,2,3,4]]).size.must_equal 1
        Seps.from_blocks([B[0], B[1], B[2], B[3], B[4]]).size.must_equal 10
        Seps.new([B[1,2,3], B[0,2,3], B[0,1], B[0,1]]).size.must_equal 5
      end
    end

    describe '#to_column' do
      it 'returns a proper column' do
        {
          [] => %i(),
          [0b10, 0b01] => %i(a b),
          [
            0b11110,
            0b11101,
            0b10011,
            0b10011,
            0b01111,
          ] => %i(a b c c d),
          [
            0b10010,
            0b11101,
            0b10010,
            0b10010,
            0b01111,
          ] => %i(a b a a c),
          [
            0b00000,
            0b10000,
            0b00000,
            0b00000,
            0b00010,
          ] => %i(- a - - b),
          [
            0b11110,
            0b11101,
            0b11011,
            0b10111,
            0b01111,
          ] => %i(a b c d e),
          [
            0b11000,
            0b00000,
            0b00000,
            0b00001,
            0b00001,
          ] => %i(a - - b b),
        }.each do |matrix, column|
          Seps.new(matrix).to_column.must_equal column
        end
      end
    end
  end
end
