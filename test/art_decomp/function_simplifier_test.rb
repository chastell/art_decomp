require_relative '../test_helper'
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

      let(:a)   { Put[%i(0 0 0 0 1 1 1 1)] }
      let(:b)   { Put[%i(0 0 1 1 0 0 1 1)] }
      let(:c)   { Put[%i(0 1 0 1 0 1 0 1)] }
      let(:anb) { Put[%i(0 0 0 0 0 0 1 1)] }
      let(:buc) { Put[%i(0 1 1 1 0 1 1 1)] }

      it 'returns the simplest implementation of a Function' do
        ab_anb  = Function.new(ins: Puts.new([a,b]),   outs: Puts.new([anb]))
        abc_anb = Function.new(ins: Puts.new([a,b,c]), outs: Puts.new([anb]))
        _(FunctionSimplifier.simplify(abc_anb)).must_equal ab_anb
      end

      it 'maintains put order' do
        abc_buc = Function.new(ins: Puts.new([a,b,c]), outs: Puts.new([buc]))
        bc_buc  = Function.new(ins: Puts.new([b,c]),   outs: Puts.new([buc]))
        _(FunctionSimplifier.simplify(abc_buc)).must_equal bc_buc
      end

      it 'does not modify Functions that are the simplest already' do
        ab_anb = Function.new(ins: Puts.new([a,b]), outs: Puts.new([anb]))
        _(FunctionSimplifier.simplify(ab_anb)).must_equal ab_anb
      end
    end
  end
end
