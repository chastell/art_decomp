require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_presenter'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionPresenter do
    describe '#rows' do
      it 'returns binary-encoded row representation of the Function' do
        ins  = Puts.from_columns([%i(0 - 1 - - 1 0 - - -),
                                  %i(- 0 1 - - 0 - 1 - -),
                                  %i(- - - 0 1 - - - 0 1)]) +
               Puts.from_columns([%i(HG HG HG HY HY FG FG FG FY FY)])
        outs = Puts.from_columns([%i(0 0 1 0 1 0 1 1 0 1),
                                  %i(0 0 0 0 0 1 1 1 1 1),
                                  %i(0 0 0 1 1 0 0 0 0 0),
                                  %i(1 1 1 1 1 0 0 0 0 0),
                                  %i(0 0 0 0 0 0 0 0 1 1)]) +
               Puts.from_columns([%i(HG HG HY HY FG FG FY FY FY HG)])
        function = Function.new(ins: ins, outs: outs)
        function_presenter = FunctionPresenter.new(function)
        _(function_presenter.rows).must_equal [
          %w(0--10 0001010),
          %w(-0-10 0001010),
          %w(11-10 1001011),
          %w(--011 0011011),
          %w(--111 1011000),
          %w(10-00 0100000),
          %w(0--00 1100001),
          %w(-1-00 1100001),
          %w(--001 0100101),
          %w(--101 1100110),
        ]
      end
    end
  end
end
