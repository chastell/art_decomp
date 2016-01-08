require_relative '../../test_helper'
require_relative '../../../lib/art_decomp/circuit'
require_relative '../../../lib/art_decomp/function'
require_relative '../../../lib/art_decomp/function_decomposer/parallel'
require_relative '../../../lib/art_decomp/kiss_parser'
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
        a     = Put[%i(0 0 0 0 1 1 1 1)]
        b     = Put[%i(0 0 1 1 0 0 1 1)]
        c     = Put[%i(0 1 0 1 0 1 0 1)]
        anb   = Put[%i(0 0 0 0 0 0 1 1)]
        buc   = Put[%i(0 1 1 1 0 1 1 1)]
        nbuc  = Put[%i(1 0 0 0 1 0 0 0)]
        ab    = Function.new(ins: Puts.new([a, b]), outs: Puts.new([anb]))
        bc    = Function.new(ins: Puts.new([b, c]), outs: Puts.new([buc, nbuc]))
        ins   = Puts.new([a, b, c])
        outs  = Puts.new([anb, buc, nbuc])
        wires = Wires.from_array([
          [[:circuit, ins,     a],    [ab,       ab.ins, a]],
          [[:circuit, ins,     b],    [ab,       ab.ins, b]],
          [[ab,       ab.outs, anb],  [:circuit, outs,   anb]],
          [[:circuit, ins,     b],    [bc,       bc.ins, b]],
          [[:circuit, ins,     c],    [bc,       bc.ins, c]],
          [[bc,       bc.outs, buc],  [:circuit, outs,   buc]],
          [[bc,       bc.outs, nbuc], [:circuit, outs,   nbuc]],
        ])
        circuit = Circuit.new(functions: [ab, bc], lines: {},
                              own: Function.new(ins: ins, outs: outs),
                              wires: wires)
        fun = Function.new(ins: ins, outs: outs)
        _(FunctionDecomposer::Parallel.decompose(fun)).must_include circuit
      end

      it 'does not yield if it can’t decompose' do
        fun = KISSParser.function_for <<-end
          00 0
          01 0
          10 0
          11 1
        end
        _(FunctionDecomposer::Parallel.decompose(fun).to_a).must_be_empty
      end
    end
  end
end
