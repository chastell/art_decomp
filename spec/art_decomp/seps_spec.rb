require_relative '../spec_helper'

module ArtDecomp describe Seps do
  describe '.[]' do
    it 'creates Seps from the given blocks' do
      Seps[B[0,1], B[1,2]].must_equal Seps.new(blocks: [B[0,1], B[1,2]])
      Seps[].must_equal Seps.new
    end
  end

  describe '.new' do
    it 'can take a matrix to start from' do
      Seps.new(matrix: [0b100, 0b000, 0b001]).must_equal Seps[B[0,1], B[1,2]]
    end

    it 'normalises the matrix' do
      Seps[B[0,1,2]].must_equal Seps.new matrix: []
    end

    it 'builds a proper matrix' do
      Seps[].must_equal Seps.new matrix: []
      Seps[B[0]].must_equal Seps.new matrix: []
      Seps[B[0,1]].must_equal Seps.new matrix: []
      Seps[B[0], B[1]].must_equal Seps.new matrix: [0b10, 0b01]
      Seps[B[0], B[1], B[2,3], B[4]].must_equal Seps.new matrix:
        [0b11110, 0b11101, 0b10011, 0b10011, 0b01111]
      Seps[B[1], B[4]].must_equal Seps.new matrix:
        [0b10010, 0b11101, 0b10010, 0b10010, 0b01111]
      Seps[B[0,2,3], B[1], B[4]].must_equal Seps.new matrix:
        [0b10010, 0b11101, 0b10010, 0b10010, 0b01111]
      Seps[B[0,1,2,3], B[0,2,3,4]].must_equal Seps.new matrix:
        [0b00000, 0b10000, 0b00000, 0b00000, 0b00010]
      Seps[B[0], B[1], B[2], B[3], B[4]].must_equal Seps.new matrix:
        [0b11110, 0b11101, 0b11011, 0b10111, 0b01111]
      Seps[B[0,1,2], B[1,2,3,4]].must_equal Seps.new matrix:
        [0b11000, 0b00000, 0b00000, 0b00001, 0b00001]
    end
  end

  describe '#&' do
    it 'returns the conjunction of the Seps' do
      sep_01          = Seps.new matrix: [0b10, 0b01]
      sep_01_02       = Seps.new matrix: [0b110, 0b001, 0b001]
      sep_01_12       = Seps.new matrix: [0b010, 0b101, 0b010]
      sep_01_02_12    = Seps.new matrix: [0b110, 0b101, 0b011]
      sep_01_02_03_13 = Seps.new matrix: [0b1110, 0b1001, 0b0001, 0b0011]
      (sep_01_02 & sep_01_12).must_equal sep_01
      (sep_01_02_03_13 & sep_01_02_12).must_equal sep_01_02
      (sep_01_02_12 & sep_01_02_03_13).must_equal sep_01_02
    end
  end

  describe '#+' do
    it 'returns the disjunction of the Seps' do
      sep_01_02          = Seps.new matrix: [0b110, 0b001, 0b001]
      sep_01_12          = Seps.new matrix: [0b010, 0b101, 0b010]
      sep_01_02_12       = Seps.new matrix: [0b110, 0b101, 0b011]
      sep_01_02_03_13    = Seps.new matrix: [0b1110, 0b1001, 0b0001, 0b0011]
      sep_01_02_03_12_13 = Seps.new matrix: [0b1110, 0b1101, 0b0011, 0b0011]
      (sep_01_12 + sep_01_02).must_equal sep_01_02_12
      (sep_01_02_03_13 + sep_01_02_12).must_equal sep_01_02_03_12_13
      (sep_01_02_12 + sep_01_02_03_13).must_equal sep_01_02_03_12_13
    end
  end

  describe '#==' do
    it 'compares two Seps by value' do
      assert Seps[B[0,1], B[1,2]] == Seps[B[0,1], B[1,2]].dup
      assert Seps[B[0,1], B[1,2]] == Seps[B[1,2], B[0,1]]
      refute Seps[B[0,1], B[1,2]] == Seps[B[0,2], B[1,2]]
    end
  end

  describe '#empty?' do
    it 'returns a predicate whether the Seps are empty' do
      Seps[].must_be :empty?
      Seps[B[0,1]].must_be :empty?
      Seps[B[0], B[1]].wont_be :empty?
    end
  end

  describe '#inspect' do
    it 'returns self-initialising representation' do
      Seps[].inspect.must_equal "ArtDecomp::Seps.new matrix: []"
      Seps.new(matrix: [0b100, 0b000, 0b001]).inspect
        .must_equal "ArtDecomp::Seps.new matrix: [0b100, 0b000, 0b001]"
    end
  end

  describe '#size' do
    it 'returns the number of separations' do
      Seps[].size.must_equal 0
      Seps[B[0], B[1]].size.must_equal 1
      Seps[B[0,1,2], B[1,2,3,4]].size.must_equal 2
      Seps[B[0,2,3], B[1], B[4]].size.must_equal 7
      Seps[B[0,1,2,3], B[0,2,3,4]].size.must_equal 1
      Seps[B[0], B[1], B[2], B[3], B[4]].size.must_equal 10
      Seps.new(matrix: [0b1110, 0b1101, 0b0011, 0b0011]).size.must_equal 5
    end
  end
end end
