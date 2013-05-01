require_relative '../spec_helper'

module ArtDecomp describe Put do
  let(:put) { Put[a: B[0,1], b: B[1,2]] }

  describe '.[]' do
    it 'creates a new Put with the given blanket' do
      put.must_equal Put.new blanket: { a: B[0,1], b: B[1,2] }
      Put[].must_equal Put.new
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
      Put[a: B[0]].width.must_equal 0
      Put[a: B[0], b: B[1]].width.must_equal 1
      Put[a: B[0], b: B[1], c: B[2]].width.must_equal 2
      Put[a: B[0], b: B[1], c: B[2], d: B[3], e: B[4], f: B[5], g: B[6],
        h: B[7]].width.must_equal 3
      Put[a: B[0], b: B[1], c: B[2], d: B[3], e: B[4], f: B[5], g: B[6],
        h: B[7], i: B[8]].width.must_equal 4
    end
  end
end end
