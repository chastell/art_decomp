require_relative '../test_helper'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/dst_pin'

module ArtDecomp
  describe DstPin do
    describe '#group' do
      let(:fun) do
        KISSParser.function_for <<-end
          0 1
          1 0
        end
      end

      it 'must be :outs for circuit pins' do
        put = fun.ins.first
        _(DstPin[:circuit, :outs, fun.ins, put].group).must_equal :outs
      end

      it 'must be :ins for function pins' do
        _(DstPin[fun, :ins, fun.outs, fun.outs.first].group).must_equal :ins
      end
    end
  end
end
