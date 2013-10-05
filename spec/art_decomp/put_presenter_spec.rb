require_relative '../spec_helper'

module ArtDecomp describe PutPresenter do
  describe '#bin_column' do
    it 'returns the binary column representing the Put' do
      PutPresenter.new(Put[a: B[0,1], b: B[1,2]]).bin_column
        .must_equal %w[0 - 1]
      PutPresenter.new(Put[a: B[0], b: B[1], c: B[2]]).bin_column
        .must_equal %w[00 01 10]
    end
  end

  describe '#mapping_for' do
    it 'returns a String version of the binary mapping for a given code' do
      put_presenter = PutPresenter.new Put[a: B[0,1], b: B[1,2]]
      put_presenter.mapping_for(:a).must_equal '0'
      put_presenter.mapping_for(:b).must_equal '1'
      three_block_put = Put[a: B[0], b: B[1], c: B[2]]
      PutPresenter.new(three_block_put).mapping_for(:b).must_equal '01'
    end
  end
end end
