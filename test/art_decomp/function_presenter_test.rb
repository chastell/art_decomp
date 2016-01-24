require_relative '../test_helper'
require_relative '../../lib/art_decomp/fsm_kiss_parser'
require_relative '../../lib/art_decomp/function_presenter'

module ArtDecomp
  describe FunctionPresenter do
    let(:function_presenter) do
      function = FSMKISSParser.function_for <<-end
        0-- HG HG 00010
        -0- HG HG 00010
        11- HG HY 10010
        --0 HY HY 00110
        --1 HY FG 10110
        10- FG FG 01000
        0-- FG FY 11000
        -1- FG FY 11000
        --0 FY FY 01001
        --1 FY HG 11001
      end
      FunctionPresenter.new(function)
    end

    describe '#simple' do
      it 'returns a simple String representation of the Function' do
        _(function_presenter.simple).must_equal <<~end
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
