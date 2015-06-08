require_relative '../../test_helper'
require_relative '../../../lib/art_decomp/circuit'
require_relative '../../../lib/art_decomp/function'
require_relative '../../../lib/art_decomp/function_decomposer/parallel'
require_relative '../../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionDecomposer::Parallel do
    describe '.decompose' do
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

      it 'yields decomposed Circuits' do
        a    = Put[%i(0 0 0 0 1 1 1 1)]
        b    = Put[%i(0 0 1 1 0 0 1 1)]
        c    = Put[%i(0 1 0 1 0 1 0 1)]
        anb  = Put[%i(0 0 0 0 0 0 1 1)]
        buc  = Put[%i(0 1 1 1 0 1 1 1)]
        nbuc = Put[%i(1 0 0 0 1 0 0 0)]
        ab_anb      = Function.new(ins:  Puts.new([a, b]),
                                   outs: Puts.new([anb]))
        bc_buc_nbuc = Function.new(ins:  Puts.new([b, c]),
                                   outs: Puts.new([buc, nbuc]))
        ins   = Puts.new([a, b, c])
        outs  = Puts.new([anb, buc, nbuc])
        wires = Wires.from_array([
          [[:circuit, :ins, ins, a], [ab_anb, :ins, ab_anb.ins, a]],
          [[:circuit, :ins, ins, b], [ab_anb, :ins, ab_anb.ins, b]],
          [[ab_anb, :outs, ab_anb.outs, anb], [:circuit, :outs, outs, anb]],
          [[:circuit, :ins, ins, b], [bc_buc_nbuc, :ins, bc_buc_nbuc.ins, b]],
          [[:circuit, :ins, ins, c], [bc_buc_nbuc, :ins, bc_buc_nbuc.ins, c]],
          [[bc_buc_nbuc, :outs, bc_buc_nbuc.outs, buc],
           [:circuit, :outs, outs, buc]],
          [[bc_buc_nbuc, :outs, bc_buc_nbuc.outs, nbuc],
           [:circuit, :outs, outs, nbuc]],
        ])
        circuit = Circuit.new(functions: [ab_anb, bc_buc_nbuc], wires: wires)
        fun = Function.new(ins: ins, outs: outs)
        FunctionDecomposer::Parallel.decompose(fun).to_a.must_equal [circuit]
      end

      it 'does not yield if it can’t decompose' do
        a   = %i(0 0 0 0 1 1 1 1)
        b   = %i(0 0 1 1 0 0 1 1)
        anb = %i(0 0 0 0 0 0 1 1)
        fun = Function.new(ins:  Puts.from_columns([a,b]),
                           outs: Puts.from_columns([anb]))
        FunctionDecomposer::Parallel.decompose(fun).to_a.must_be_empty
      end
    end
  end
end
