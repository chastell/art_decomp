require_relative '../spec_helper'

module ArtDecomp describe Put do
  let(:put) { Put[a: B[0,1], b: B[1,2]] }

  describe '.[]' do
    it 'creates a new Put with the given blanket' do
      put.must_equal Put.new blanket: { a: B[0,1], b: B[1,2] }
      Put[].must_equal Put.new
    end
  end

  describe '#==' do
    it 'compares two Puts by value' do
      assert put == put.dup
      assert put == Put[b: B[1,2], a: B[0,1]]
      refute put == Put[a: B[1,2], b: B[0,1]]
    end
  end

  describe '#binwidth' do
    it 'returns the binary width' do
      Put[].binwidth.must_equal 0
      Put[a: 1].binwidth.must_equal 0
      Put[a: 1, b: 2].binwidth.must_equal 1
      Put[a: 1, b: 2, c: 3].binwidth.must_equal 2
      Put[a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8].binwidth.must_equal 3
      Put[a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9].binwidth
        .must_equal 4
    end
  end

  describe '#blocks' do
    it 'returns blocks' do
      put.blocks.must_equal [B[0,1], B[1,2]]
    end
  end

  describe '#codes' do
    it 'returns codes' do
      put.codes.must_equal [:a, :b]
    end

    it 'allows requesting just certain codes' do
      put.codes { |code, block| code < :b }.must_equal [:a]
      put.codes { |code, block| (block & B[2]).nonzero? }.must_equal [:b]
    end
  end

  describe '#inspect' do
    it 'returns self-initialising representation' do
      Put[a: B[0,1], b: B[1,2]].inspect
        .must_equal 'ArtDecomp::Put[:a => B[0,1], :b => B[1,2]]'
    end
  end

  describe '#mapping_for' do
    it 'returns a String version of the binary mapping for a given code' do
      put.mapping_for(:a).must_equal '0'
      put.mapping_for(:b).must_equal '1'
      Put[a: B[0], b: B[1], c: B[2]].mapping_for(:b).must_equal '01'
    end
  end

  describe '#seps' do
    it 'returns the Put’s Seps' do
      put.seps.must_equal Seps[B[0,1], B[1,2]]
    end
  end

  describe '#size' do
    it 'returns size' do
      put.size.must_equal 2
    end
  end
end end
