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
end end
