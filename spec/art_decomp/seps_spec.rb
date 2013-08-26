require_relative '../spec_helper'

module ArtDecomp describe Seps do
  let(:sep_01)          { Seps.new matrix: [B[1], B[0]]                     }
  let(:sep_01_02)       { Seps.new matrix: [B[1,2], B[0], B[0]]             }
  let(:sep_01_02_03_13) { Seps.new matrix: [B[1,2,3], B[0,3], B[0], B[0,1]] }
  let(:sep_01_02_12)    { Seps.new matrix: [B[1,2], B[0,2], B[0,1]]         }
  let(:sep_01_12)       { Seps.new matrix: [B[1], B[0,2], B[1]]             }
  let(:sep_03_13)       { Seps.new matrix: [B[3], B[3], B[], B[0,1]]        }
  let(:sep_12)          { Seps.new matrix: [B[], B[2], B[1]]                }

  describe '.[]' do
    it 'creates Seps from the given blocks' do
      Seps[B[0,1], B[1,2]].must_equal Seps.new(blocks: [B[0,1], B[1,2]])
      Seps[].must_equal Seps.new
    end
  end

  describe '.new' do
    it 'can take a matrix to start from' do
      Seps.new(matrix: [B[2], B[], B[0]]).must_equal Seps[B[0,1], B[1,2]]
    end

    it 'normalises the matrix' do
      Seps[B[0,1,2]].must_equal Seps.new matrix: []
    end

    it 'builds a proper matrix' do
      Seps[].must_equal Seps.new matrix: []
      Seps[B[0]].must_equal Seps.new matrix: []
      Seps[B[0,1]].must_equal Seps.new matrix: []
      Seps[B[0], B[1]].must_equal Seps.new matrix: [B[1], B[0]]
      Seps[B[0], B[1], B[2,3], B[4]].must_equal Seps.new matrix:
        [B[4,3,2,1], B[4,3,2,0], B[4,1,0], B[4,1,0], B[3,2,1,0]]
      Seps[B[1], B[4]].must_equal Seps.new matrix:
        [B[4,1], B[4,3,2,0], B[4,1], B[4,1], B[3,2,1,0]]
      Seps[B[0,2,3], B[1], B[4]].must_equal Seps.new matrix:
        [B[4,1], B[4,3,2,0], B[4,1], B[4,1], B[3,2,1,0]]
      Seps[B[0,1,2,3], B[0,2,3,4]].must_equal Seps.new matrix:
        [B[], B[4], B[], B[], B[1]]
      Seps[B[0], B[1], B[2], B[3], B[4]].must_equal Seps.new matrix:
        [B[4,3,2,1], B[4,3,2,0], B[4,3,1,0], B[4,2,1,0], B[3,2,1,0]]
      Seps[B[0,1,2], B[1,2,3,4]].must_equal Seps.new matrix:
        [B[4,3], B[], B[], B[0], B[0]]
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
      assert Seps[B[0,1], B[1,2]] == Seps[B[0,1], B[1,2]].dup
      assert Seps[B[0,1], B[1,2]] == Seps[B[1,2], B[0,1]]
      refute Seps[B[0,1], B[1,2]] == Seps[B[0,2], B[1,2]]
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
      Seps[].must_be :empty?
      Seps[B[0,1]].must_be :empty?
      Seps[B[0], B[1]].wont_be :empty?
    end
  end

  describe '#inspect' do
    it 'returns self-initialising representation' do
      Seps[].inspect.must_equal 'ArtDecomp::Seps.new matrix: []'
      Seps.new(matrix: [B[2], B[], B[0]]).inspect
        .must_equal 'ArtDecomp::Seps.new matrix: [B[2], B[], B[0]]'
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
      Seps.new(matrix: [B[1,2,3], B[0,2,3], B[0,1], B[0,1]]).size.must_equal 5
    end
  end
end end
