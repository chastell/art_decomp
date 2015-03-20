require_relative '../../test_helper'
require_relative '../../../lib/art_decomp/circuit'
require_relative '../../../lib/art_decomp/function'
require_relative '../../../lib/art_decomp/function_decomposer/parallel'
require_relative '../../../lib/art_decomp/put'
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
        ab_anb      = Function.new(ins: Puts.new([a,b]), outs: Puts.new([anb]))
        bc_buc_nbuc = Function.new(ins: Puts.new([b,c]),
                                   outs: Puts.new([buc, nbuc]))
        wires = Wires.from_array([
          [[:circuit,    :ins,  0], [ab_anb,      :ins,  0]],
          [[:circuit,    :ins,  1], [ab_anb,      :ins,  1]],
          [[ab_anb,      :outs, 0], [:circuit,    :outs, 0]],
          [[:circuit,    :ins,  1], [bc_buc_nbuc, :ins,  0]],
          [[:circuit,    :ins,  2], [bc_buc_nbuc, :ins,  1]],
          [[bc_buc_nbuc, :outs, 0], [:circuit,    :outs, 1]],
          [[bc_buc_nbuc, :outs, 1], [:circuit,    :outs, 2]],
        ])
        circuit = Circuit.new(functions: [ab_anb, bc_buc_nbuc],
                              ins: Puts.new([a, b, c]),
                              outs: Puts.new([anb, buc, nbuc]),
                              states: Puts.new,
                              next_states: Puts.new,
                              recoders: [],
                              wires: wires)
        fun = Function.new(ins: Puts.new([a,b,c]),
                           outs: Puts.new([anb,buc,nbuc]))
        FunctionDecomposer::Parallel.decompose(fun).to_a.must_equal [circuit]
      end

      it 'does not yield if it can’t decompose' do
        a   = Put[%i(0 0 0 0 1 1 1 1)]
        b   = Put[%i(0 0 1 1 0 0 1 1)]
        anb = Put[%i(0 0 0 0 0 0 1 1)]
        fun = Function.new(ins: Puts.new([a,b]), outs: Puts.new([anb]))
        FunctionDecomposer::Parallel.decompose(fun).to_a.must_be_empty
      end
    end
  end
end
