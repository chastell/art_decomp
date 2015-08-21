require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_presenter'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionPresenter do
    let(:function_presenter) do
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
      FunctionPresenter.new(Function.new(ins: ins, outs: outs))
    end

    describe '#simple' do
      it 'returns a simple String representation of the Function' do
        _(function_presenter.simple).must_equal <<-end.dedent
          0 - - HG | 0 0 0 1 0 HG
          - 0 - HG | 0 0 0 1 0 HG
          1 1 - HG | 1 0 0 1 0 HY
          - - 0 HY | 0 0 1 1 0 HY
          - - 1 HY | 1 0 1 1 0 FG
          1 0 - FG | 0 1 0 0 0 FG
          0 - - FG | 1 1 0 0 0 FY
          - 1 - FG | 1 1 0 0 0 FY
          - - 0 FY | 0 1 0 0 1 FY
          - - 1 FY | 1 1 0 0 1 HG
        end
      end
    end

    describe '#rows' do
      it 'returns binary-encoded row representation of the Function' do
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
