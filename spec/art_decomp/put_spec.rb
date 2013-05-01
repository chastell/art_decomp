require_relative '../spec_helper'

module ArtDecomp describe Put do
  describe '.[]' do
    it 'creates a new Put with the given blanket' do
      Put[a: B[0,1], b: B[1,2]]
        .must_equal Put.new blanket: { a: B[0,1], b: B[1,2] }
    end
  end

  describe '#blocks' do
    it 'returns the blanket’s blocks' do
      Put[a: B[0,1], b: B[1,2]].blocks.must_equal [B[0,1], B[1,2]]
    end
  end

  describe '#codes' do
    it 'returns the blanket’s codes' do
      Put[a: B[0,1], b: B[1,2]].codes.must_equal [:a, :b]
    end
  end

  describe '#size' do
    it 'returns the size of the blanket' do
      Put[a: B[0,1], b: B[1,2]].size.must_equal 2
    end
  end
end end
