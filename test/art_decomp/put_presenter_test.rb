require_relative '../test_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/put_presenter'

module ArtDecomp
  describe PutPresenter do
    describe '#bin_column' do
      it 'returns binary column representation of the Put' do
        PutPresenter.new(Put[:'0', :-, :'1']).bin_column.must_equal %w(0 - 1)
      end

      it 'represents inputs alphabetically with enough bits' do
        put = Put[:HG, :HG, :HY, :FG, :FY, :-]
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
  end
end
