require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_simplifier'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionSimplifier do
    describe '.simplify' do
      #   | a b c | anb buc
      # --+-------+--------
      # 0 | 0 0 0 |  0   0
      # 1 | 0 0 1 |  0   1
      # 2 | 0 1 0 |  0   1
      # 3 | 0 1 1 |  0   1
      # 4 | 1 0 0 |  0   0
      # 5 | 1 0 1 |  0   1
      # 6 | 1 1 0 |  1   1
      # 7 | 1 1 1 |  1   1

      let(:a)   { Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]] }
      let(:b)   { Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]] }
      let(:c)   { Put[:'0' => B[0,2,4,6], :'1' => B[1,3,5,7]] }
      let(:anb) { Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]] }
      let(:buc) { Put[:'0' => B[0,4], :'1' => B[1,2,3,5,6,7]] }

      it 'returns the simplest implementation of a Function' do
        ab_anb  = Function.new(Puts.new(is: [a,b],   os: [anb]))
        abc_anb = Function.new(Puts.new(is: [a,b,c], os: [anb]))
        FunctionSimplifier.simplify(abc_anb).must_equal ab_anb
      end

      it 'maintains put order' do
        abc_buc = Function.new(Puts.new(is: [a,b,c], os: [buc]))
        bc_buc  = Function.new(Puts.new(is: [b,c],   os: [buc]))
        FunctionSimplifier.simplify(abc_buc).must_equal bc_buc
      end

      it 'does not modify Functions that are the simplest already' do
        ab_anb = Function.new(Puts.new(is: [a,b], os: [anb]))
        FunctionSimplifier.simplify(ab_anb).must_equal ab_anb
      end
    end
  end
end
