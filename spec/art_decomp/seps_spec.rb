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
        [0b11111, 0b11101, 0b11111, 0b11111, 0b01111]
      Seps[B[0,1,2,3], B[0,2,3,4]].must_equal Seps.new matrix:
        [0b00000, 0b10000, 0b00000, 0b00000, 0b00010]
      Seps[B[0], B[1], B[2], B[3], B[4]].must_equal Seps.new matrix:
        [0b11110, 0b11101, 0b11011, 0b10111, 0b01111]
    end
  end

  describe '#==' do
    it 'compares two Seps by value' do
      assert Seps[B[0,1], B[1,2]] == Seps[B[0,1], B[1,2]].dup
      assert Seps[B[0,1], B[1,2]] == Seps[B[1,2], B[0,1]]
      refute Seps[B[0,1], B[1,2]] == Seps[B[0,2], B[1,2]]
    end
  end
end end
