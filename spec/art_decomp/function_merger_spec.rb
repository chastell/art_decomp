require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_merger'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/puts_set'

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

      let(:f1) do
        Function.new(PutsSet.new(is: Puts.new([a,b]), os: Puts.new([anb])))
      end
      let(:f2) do
        Function.new(PutsSet.new(is: Puts.new([b,c]), os: Puts.new([buc])))
      end
      let(:f3) do
        Function.new(PutsSet.new(is: Puts.new([b,c]), os: Puts.new([nbuc])))
      end
      let(:f4) do
        Function.new(PutsSet.new(is: Puts.new([c,b]), os: Puts.new([nbuc])))
      end
      let(:f23) do
        Function.new(PutsSet.new(is: Puts.new([b,c]), os: Puts.new([buc,nbuc])))
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
