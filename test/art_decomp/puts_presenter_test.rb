require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/puts_presenter'

module ArtDecomp
  describe PutsPresenter do
    describe '#bin_columns' do
      it 'returns binary-encoded column representation of the Puts' do
        puts = Puts.new([
          Put[%i(0 - 1 - - 1 0 - - -)],
          Put[%i(- 0 1 - - 0 - 1 - -)],
          Put[%i(- - - 0 1 - - - 0 1)],
          Put[%i(HG HG HG HY HY FG FG FG FY FY)],
        ])
        PutsPresenter.new(puts).bin_columns.must_equal %w(
          0--10
          -0-10
          11-10
          --011
          --111
          10-00
          0--00
          -1-00
          --001
          --101
        )
      end
    end
  end
end
