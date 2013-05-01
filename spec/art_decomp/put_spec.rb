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
end end
