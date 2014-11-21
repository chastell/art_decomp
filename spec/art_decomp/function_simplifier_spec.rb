require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_simplifier'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionSimplifier do
    describe '.simplify' do
      it 'returns the simplest implementation of a Function' do
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
        a   = Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]]
        b   = Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]]
        c   = Put[:'0' => B[0,2,4,6], :'1' => B[1,3,5,7]]
        anb = Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]]
        buc = Put[:'0' => B[0,4], :'1' => B[1,2,3,5,6,7]]
        ab_anb  = Function.new(Puts.new(is: [a,b],   os: [anb]))
        abc_anb = Function.new(Puts.new(is: [a,b,c], os: [anb]))
        abc_buc = Function.new(Puts.new(is: [a,b,c], os: [buc]))
        cb_buc  = Function.new(Puts.new(is: [c,b],   os: [buc]))
        FunctionSimplifier.simplify(abc_anb).must_equal ab_anb
        FunctionSimplifier.simplify(abc_buc).must_equal cb_buc
      end
    end
  end
end
