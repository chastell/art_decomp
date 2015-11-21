require_relative '../test_helper'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/src_pin'

module ArtDecomp
  describe SrcPin do
    describe '#group' do
      let(:fun) do
        KISSParser.function_for <<-end
          0 1
          1 0
        end
      end

      it 'must be :ins for circuit pins' do
        _(SrcPin[:circuit, :ins, fun.ins, fun.ins.first].group).must_equal :ins
      end

      it 'must be :outs for function pins' do
        _(SrcPin[fun, :outs, fun.outs, fun.outs.first].group).must_equal :outs
      end
    end
  end
end
