require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_merger'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionMerger do
    describe '.merge' do
      #   | a b c | anb buc nbuc
      # --+-------+-------------
      # 0 | 0 0 0 |  0   0   1
      # 1 | 0 0 1 |  0   1   0
      # 2 | 0 1 0 |  0   1   0
      # 3 | 0 1 1 |  0   1   0
      # 4 | 1 0 0 |  0   0   1
      # 5 | 1 0 1 |  0   1   0
      # 6 | 1 1 0 |  1   1   0
      # 7 | 1 1 1 |  1   1   0
      let(:a)    { %i(0 0 0 0 1 1 1 1) }
      let(:b)    { %i(0 0 1 1 0 0 1 1) }
      let(:c)    { %i(0 1 0 1 0 1 0 1) }
      let(:anb)  { %i(0 0 0 0 0 0 1 1) }
      let(:buc)  { %i(0 1 1 1 0 1 1 1) }
      let(:nbuc) { %i(1 0 0 0 1 0 0 0) }

      let(:f1) { Function[Puts.from_columns([a,b]), Puts.from_columns([anb])]  }
      let(:f2) { Function[Puts.from_columns([b,c]), Puts.from_columns([buc])]  }
      let(:f3) { Function[Puts.from_columns([b,c]), Puts.from_columns([nbuc])] }
      let(:f4) { Function[Puts.from_columns([c,b]), Puts.from_columns([nbuc])] }

      let(:f23) do
        Function[Puts.from_columns([b,c]), Puts.from_columns([buc,nbuc])]
      end

      it 'merges passed Functions according to their inputs' do
        _(FunctionMerger.merge([f1, f2, f3])).must_equal [f1, f23]
      end

      it 'optimises the merged functions' do
        _(FunctionMerger.merge([f1, f2, f3, f2])).must_equal [f1, f23]
      end

      it 'doesn’t discriminate by input order' do
        _(FunctionMerger.merge([f1, f2, f4])).must_equal [f1, f23]
      end
    end
  end
end
