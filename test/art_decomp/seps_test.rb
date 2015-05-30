require_relative '../test_helper'
require_relative '../../lib/art_decomp/seps'

module ArtDecomp                          # rubocop:disable Metrics/ModuleLength
  describe Seps do
    let(:sep_01)          { Seps.new([0b10, 0b01])                     }
    let(:sep_01_02)       { Seps.new([0b110, 0b001, 0b001])            }
    let(:sep_01_02_03_13) { Seps.new([0b1110, 0b1001, 0b0001, 0b0011]) }
    let(:sep_01_02_12)    { Seps.new([0b110, 0b101, 0b011])            }
    let(:sep_01_12)       { Seps.new([0b010, 0b101, 0b010])            }
    let(:sep_03_13)       { Seps.new([0b1000, 0b1000, 0b0000, 0b0011]) }
    let(:sep_12)          { Seps.new([0b000, 0b100, 0b010])            }

    let(:column_to_matrix) do
      {
        %i()    => [],
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
      }
    end

    describe '.from_column' do
      it 'builds a proper matrix' do
        column_to_matrix.each do |column, matrix|
          Seps.from_column(column).must_equal Seps.new(matrix)
        end
        Seps.from_column(%i(a)).must_equal Seps.new([])
        Seps.from_column(%i(a a)).must_equal Seps.new([])
      end
    end

    describe '.new' do
      it 'can take a matrix to start from' do
        Seps.new([0b100, 0b000, 0b001]).must_equal Seps.from_column(%i(a - b))
      end

      it 'normalises the matrix' do
        Seps.from_column(%i(a a)).must_equal Seps.new([])
        Seps.new([0b000, 0b000, 0b000]).must_equal Seps.new([])
        Seps.new([0b010, 0b001, 0b000]).must_equal Seps.new([0b10, 0b01])
        Seps.new([0b000, 0b100, 0b000])
          .must_equal Seps.new([0b000, 0b100, 0b000])
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
        assert Seps.from_column(%i(a - b)) == Seps.from_column(%i(a - b)).dup
        assert Seps.from_column(%i(a - b)) == Seps.from_column(%i(b - a))
        refute Seps.from_column(%i(a - b)) == Seps.from_column(%i(a b))
      end
    end

    describe '#|' do
      it 'returns the disjunction of the Seps' do
        (sep_01_12 | sep_01_02).must_equal sep_01_02_12
        (sep_01_02 | sep_12).must_equal sep_01_02_12
        (sep_12 | sep_01_02).must_equal sep_01_02_12
      end
    end

    describe '#count' do
      it 'returns the number of separations' do
        Seps.from_column([]).count.must_equal 0
        Seps.from_column(%i(a b)).count.must_equal 1
        Seps.from_column(%i(a - - b b)).count.must_equal 2
        Seps.from_column(%i(a b a a c)).count.must_equal 7
        Seps.from_column(%i(- a - - b)).count.must_equal 1
        Seps.from_column(%i(a b c d e)).count.must_equal 10
        Seps.from_column(%i(a b c c)).count.must_equal 5
      end
    end

    describe '#empty?' do
      it 'returns a predicate whether the Seps are empty' do
        Seps.from_column([]).must_be :empty?
        Seps.from_column(%i(a a)).must_be :empty?
        Seps.from_column(%i(a b)).wont_be :empty?
      end
    end

    describe '#inspect' do
      it 'returns a self-initialising representation' do
        Seps.from_column([]).inspect.must_equal 'ArtDecomp::Seps.new([])'
        Seps.from_column(%i(a - b)).inspect
          .must_equal 'ArtDecomp::Seps.new([0b100, 0b000, 0b001])'
      end
    end

    describe '#to_column' do
      it 'returns a proper column' do
        column_to_matrix.each do |column, matrix|
          Seps.new(matrix).to_column.must_equal column
        end
      end
    end
  end
end
