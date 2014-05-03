require_relative '../spec_helper'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/put_presenter'

module ArtDecomp describe PutPresenter do
  describe '#bin_column' do
    it 'returns binary column representation of the Put' do
      put = Put[:'0' => B[0,1], :'1' => B[1,2]]
      PutPresenter.new(put).bin_column.must_equal %w(0 - 1)
    end

    it 'represents inputs alphabetically with enough bits' do
      put = Put[HG: B[0,1,5], HY: B[2,5], FG: B[3,5], FY: B[4,5]]
      PutPresenter.new(put).bin_column.must_equal %w(
        10
        10
        11
        00
        01
        --
      )
    end
  end
end end
