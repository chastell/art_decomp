require_relative '../../test_helper'
require_relative '../../../lib/art_decomp/circuit'
require_relative '../../../lib/art_decomp/function'
require_relative '../../../lib/art_decomp/function_decomposer/serial'
require_relative '../../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionDecomposer::Serial do
    describe '.decompose' do
      it 'yields decomposed Circuits' do
        ins_f = Puts.from_columns([
          %i(0 0 - 0 0 - 1 0 - 1),
          %i(1 1 1 1 0 - - 0 1 -),
          %i(0 0 0 0 1 1 1 - 0 1),
          %i(1 - 0 1 - 1 1 - 0 0),
          %i(- 0 0 1 - - 0 - 1 -),
          %i(0 0 - - 1 1 - 0 - -),
        ])
        outs_f = Puts.from_columns([%i(0 0 0 0 0 0 0 1 1 1)])
        ins_g = Puts.from_columns([
          %i(1 - 0 1 - 1 1 - 0 0),
          %i(0 0 0 0 1 1 1 - 0 1),
          %i(- 0 0 1 - - 0 - 1 -),
        ])
        outs_g = Puts.from_columns([%i(b b b b - b b - a a)])
        ins_h = Puts.from_columns([
          %i(0 0 - 0 0 - 1 0 - 1),
          %i(1 1 1 1 0 - - 0 1 -),
          %i(0 0 - - 1 1 - 0 - -),
          %i(b b b b - b b - a a),
        ])
        outs_h = Puts.from_columns([%i(0 0 0 0 0 0 0 1 1 1)])
        f = Function.new(ins: ins_f, outs: outs_f)
        g = Function.new(ins: ins_g, outs: outs_g)
        h = Function.new(ins: ins_h, outs: outs_h)
        wires = Wires.from_array([
          [[:circuit, :ins,  3, 1, 3], [g,        :ins,  0, 1, 0]],
          [[:circuit, :ins,  2, 1, 2], [g,        :ins,  1, 1, 1]],
          [[:circuit, :ins,  4, 1, 4], [g,        :ins,  2, 1, 2]],
          [[:circuit, :ins,  0, 1, 0], [h,        :ins,  0, 1, 0]],
          [[:circuit, :ins,  1, 1, 1], [h,        :ins,  1, 1, 1]],
          [[:circuit, :ins,  5, 1, 5], [h,        :ins,  2, 1, 2]],
          [[h,        :outs, 0, 1, 0], [:circuit, :outs, 0, 1, 0]],
          [[g,        :outs, 0, 1, 0], [h,        :ins,  3, 1, 3]],
        ])
        circuit = Circuit.new(functions: [g, h], wires: wires)
        FunctionDecomposer::Serial.decompose(f).must_include circuit
      end
    end
  end
end
