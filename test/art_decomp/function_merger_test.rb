require_relative '../test_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_merger'
require_relative '../../lib/art_decomp/put'
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
      let(:a)    { Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]] }
      let(:b)    { Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]] }
      let(:c)    { Put[:'0' => B[0,2,4,6], :'1' => B[1,3,5,7]] }
      let(:anb)  { Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]] }
      let(:buc)  { Put[:'0' => B[0,4], :'1' => B[1,2,3,5,6,7]] }
      let(:nbuc) { Put[:'0' => B[1,2,3,5,6,7], :'1' => B[0,4]] }

      let(:f1) { Function.new(ins: Puts.new([a,b]), outs: Puts.new([anb]))  }
      let(:f2) { Function.new(ins: Puts.new([b,c]), outs: Puts.new([buc]))  }
      let(:f3) { Function.new(ins: Puts.new([b,c]), outs: Puts.new([nbuc])) }
      let(:f4) { Function.new(ins: Puts.new([c,b]), outs: Puts.new([nbuc])) }
      let(:f23) do
        Function.new(ins: Puts.new([b,c]), outs: Puts.new([buc,nbuc]))
      end

      it 'merges passed Functions according to their inputs' do
        FunctionMerger.merge([f1, f2, f3]).must_equal [f1, f23]
      end

      it 'optimises the merged functions' do
        FunctionMerger.merge([f1, f2, f3, f2]).must_equal [f1, f23]
      end

      it 'doesn’t discriminate by input order' do
        FunctionMerger.merge([f1, f2, f4]).must_equal [f1, f23]
      end
    end
  end
end
