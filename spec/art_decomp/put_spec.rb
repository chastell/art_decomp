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
      assert Put[a: B[0], b: B[1]] == Put[b: B[1], a: B[0]]
      refute Put[a: B[0], b: B[1]] == Put[a: B[1], b: B[0]]
    end
  end

  describe '#blocks' do
    it 'returns the blanket’s blocks' do
      put.blocks.must_equal [B[0,1], B[1,2]]
    end
  end

  describe '#codes' do
    it 'returns the blanket’s codes' do
      put.codes.must_equal [:a, :b]
    end

    it 'allows requesting just certain codes' do
      put.codes { |code, block| code < :b }.must_equal [:a]
      put.codes { |code, block| (block & B[2]).nonzero? }.must_equal [:b]
    end
  end

  describe '#size' do
    it 'returns the size of the blanket' do
      put.size.must_equal 2
    end
  end

  describe '#width' do
    it 'returns the bit width of the blanket' do
      Put[].width.must_equal 0
      Put[a: 1].width.must_equal 0
      Put[a: 1, b: 2].width.must_equal 1
      Put[a: 1, b: 2, c: 3].width.must_equal 2
      Put[a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8].width.must_equal 3
      Put[a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9].width.must_equal 4
    end
  end
end end
