require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts_presenter'

module ArtDecomp
  describe PutsPresenter do
    describe '#bin_columns' do
      it 'returns binary-encoded column representation of the Puts' do
        puts = [
          Put[:'0' => B[0,1,3,4,6,7,8,9], :'1' => B[1,2,3,4,5,7,8,9]],
          Put[:'0' => B[0,1,3,4,5,6,8,9], :'1' => B[0,2,3,4,6,7,8,9]],
          Put[:'0' => B[0,1,2,3,5,6,7,8], :'1' => B[0,1,2,4,5,6,7,9]],
          Put[HG: B[0,1,2], HY: B[3,4], FG: B[5,6,7], FY: B[8,9]],
        ]
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
