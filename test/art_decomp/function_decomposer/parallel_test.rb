require_relative '../../test_helper'
require_relative '../../../lib/art_decomp/fsm'
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

      it 'yields decomposed FSMs' do
        a    = %i(0 0 0 0 1 1 1 1)
        b    = %i(0 0 1 1 0 0 1 1)
        c    = %i(0 1 0 1 0 1 0 1)
        anb  = %i(0 0 0 0 0 0 1 1)
        buc  = %i(0 1 1 1 0 1 1 1)
        nbuc = %i(1 0 0 0 1 0 0 0)
        ab_anb      = Function.new(ins:  Puts.from_columns([a,b]),
                                   outs: Puts.from_columns([anb]))
        bc_buc_nbuc = Function.new(ins:  Puts.from_columns([b,c]),
                                   outs: Puts.from_columns([buc, nbuc]))
        wires = Wires.from_array([
          [[:circuit,    :ins,  0], [ab_anb,      :ins,  0]],
          [[:circuit,    :ins,  1], [ab_anb,      :ins,  1]],
          [[ab_anb,      :outs, 0], [:circuit,    :outs, 0]],
          [[:circuit,    :ins,  1], [bc_buc_nbuc, :ins,  0]],
          [[:circuit,    :ins,  2], [bc_buc_nbuc, :ins,  1]],
          [[bc_buc_nbuc, :outs, 0], [:circuit,    :outs, 1]],
          [[bc_buc_nbuc, :outs, 1], [:circuit,    :outs, 2]],
        ])
        fsm = FSM.new(functions: [ab_anb, bc_buc_nbuc],
                      ins: Puts.from_columns([a, b, c]),
                      outs: Puts.from_columns([anb, buc, nbuc]),
                      states: Puts.new,
                      next_states: Puts.new,
                      recoders: [],
                      wires: wires)
        fun = Function.new(ins: Puts.from_columns([a,b,c]),
                           outs: Puts.from_columns([anb,buc,nbuc]))
        FunctionDecomposer::Parallel.decompose(fun).to_a.must_equal [fsm]
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
