# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/puts_presenter'

module ArtDecomp
  describe PutsPresenter do
    let(:puts_presenter) do
      puts = Puts[%i(0 - 1 - - 1 0 - - -),
                  %i(- 0 1 - - 0 - 1 - -),
                  %i(- - - 0 1 - - - 0 1),
                  %i(HG HG HG HY HY FG FG FG FY FY)]
      PutsPresenter.new(puts)
    end

    describe '#bin_columns' do
      it 'returns binary-encoded column representation of the Puts' do
        _(puts_presenter.bin_columns).must_equal %w(
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

    describe '#simple' do
      it 'returns a simple Array representation of the Puts' do
        _(puts_presenter.simple).must_equal [
          '0 - - HG',
          '- 0 - HG',
          '1 1 - HG',
          '- - 0 HY',
          '- - 1 HY',
          '1 0 - FG',
          '0 - - FG',
          '- 1 - FG',
          '- - 0 FY',
          '- - 1 FY',
        ]
      end
    end
  end
end
