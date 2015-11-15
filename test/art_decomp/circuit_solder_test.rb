require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/circuit_solder'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe CircuitSolder do
    describe '.replace' do
      it 'returns a new Circuit with the decomposed Function replaced' do
        fun = KISSParser.function_for <<-end.dedent
          0101-0 0
          010-00 0
          -1000- 0
          01011- 0
          001--1 0
          --11-1 0
          1-110- 0
          00---0 1
          -1001- 1
          1-10-- 1
        end
        f0 = KISSParser.function_for <<-end.dedent
          01- 0
          0-0 0
          000 0
          011 0
          11- 0
          110 0
          001 1
          10- 1
        end
        f1 = KISSParser.function_for <<-end.dedent
          0100 0
          0100 0
          -1-0 0
          01-0 0
          001- 0
          --10 0
          1--0 0
          000- 1
          -1-1 1
          1--1 1
        end
        f_ins = fun.ins
        composed_wires = Wires.from_array([
          [[:circuit, :ins, f_ins, f_ins[0]], [fun, :ins, f_ins, f_ins[0]]],
          [[:circuit, :ins, f_ins, f_ins[1]], [fun, :ins, f_ins, f_ins[1]]],
          [[:circuit, :ins, f_ins, f_ins[2]], [fun, :ins, f_ins, f_ins[2]]],
          [[:circuit, :ins, f_ins, f_ins[3]], [fun, :ins, f_ins, f_ins[3]]],
          [[:circuit, :ins, f_ins, f_ins[4]], [fun, :ins, f_ins, f_ins[4]]],
          [[:circuit, :ins, f_ins, f_ins[5]], [fun, :ins, f_ins, f_ins[5]]],
          [[fun, :outs, fun.outs, fun.outs[0]],
           [:circuit, :outs, fun.outs, fun.outs[0]]],
        ])
        decomposed_wires = Wires.from_array([
          [[:circuit, :ins, f_ins, f_ins[2]], [f0, :ins, f0.ins, f0.ins[0]]],
          [[:circuit, :ins, f_ins, f_ins[3]], [f0, :ins, f0.ins, f0.ins[1]]],
          [[:circuit, :ins, f_ins, f_ins[4]], [f0, :ins, f0.ins, f0.ins[2]]],
          [[:circuit, :ins, f_ins, f_ins[0]], [f1, :ins, f1.ins, f1.ins[0]]],
          [[:circuit, :ins, f_ins, f_ins[1]], [f1, :ins, f1.ins, f1.ins[1]]],
          [[:circuit, :ins, f_ins, f_ins[5]], [f1, :ins, f1.ins, f1.ins[2]]],
          [[f0, :outs, f0.outs, f0.outs[0]], [f1, :ins, f1.ins, f1.ins[3]]],
          [[f1, :outs, f1.outs, f1.outs[0]],
           [:circuit, :outs, fun.outs, fun.outs[0]]],
        ])
        replaced_wires = Wires.from_array([
          [[:circuit, :ins, f_ins, f_ins[0]], [f1, :ins, f1.ins, f1.ins[0]]],
          [[:circuit, :ins, f_ins, f_ins[1]], [f1, :ins, f1.ins, f1.ins[1]]],
          [[:circuit, :ins, f_ins, f_ins[2]], [f0, :ins, f0.ins, f0.ins[0]]],
          [[:circuit, :ins, f_ins, f_ins[3]], [f0, :ins, f0.ins, f0.ins[1]]],
          [[:circuit, :ins, f_ins, f_ins[4]], [f0, :ins, f0.ins, f0.ins[2]]],
          [[:circuit, :ins, f_ins, f_ins[5]], [f1, :ins, f1.ins, f1.ins[2]]],
          [[f1, :outs, f1.outs, f1.outs[0]],
           [:circuit, :outs, fun.outs, fun.outs[0]]],
          [[f0, :outs, f0.outs, f0.outs[0]], [f1, :ins, f1.ins, f1.ins[3]]],
        ])
        composed   = Circuit.new(functions: [fun], wires: composed_wires)
        decomposed = Circuit.new(functions: [f0, f1], wires: decomposed_wires)
        replaced   = Circuit.new(functions: [f0, f1], wires: replaced_wires)
        result     = CircuitSolder.replace(composed: composed,
                                           decomposed: decomposed,
                                           function: fun)
        _(result).must_equal replaced
      end
    end
  end
end