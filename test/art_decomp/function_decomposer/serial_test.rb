require_relative '../../test_helper'
require_relative '../../../lib/art_decomp/circuit'
require_relative '../../../lib/art_decomp/function'
require_relative '../../../lib/art_decomp/function_decomposer/serial'
require_relative '../../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionDecomposer::Serial do
    describe '.decompose' do
      let(:f) do
        ins = Puts.from_columns([
          %i(0 0 - 0 0 - 1 0 - 1),
          %i(1 1 1 1 0 - - 0 1 -),
          %i(0 0 0 0 1 1 1 - 0 1),
          %i(1 - 0 1 - 1 1 - 0 0),
          %i(- 0 0 1 - - 0 - 1 -),
          %i(0 0 - - 1 1 - 0 - -),
        ])
        outs = Puts.from_columns([%i(0 0 0 0 0 0 0 1 1 1)])
        Function.new(ins: ins, outs: outs)
      end

      let(:g1) do
        ins = Puts.from_columns([
          %i(- 0 0 1 - - 0 - 1 -),
          %i(0 0 0 0 1 1 1 - 0 1),
          %i(1 - 0 1 - 1 1 - 0 0),
        ])
        outs = Puts.from_columns([%i(b b b b - b b - a a)])
        Function.new(ins: ins, outs: outs)
      end

      let(:h) do
        ins = Puts.from_columns([
          %i(0 0 - 0 0 - 1 0 - 1),
          %i(1 1 1 1 0 - - 0 1 -),
          %i(0 0 - - 1 1 - 0 - -),
          %i(b b b b - b b - a a),
        ])
        outs = Puts.from_columns([%i(0 0 0 0 0 0 0 1 1 1)])
        Function.new(ins: ins, outs: outs)
      end

      let(:g2) do
        ins = Puts.from_columns([
          %i(0 0 - 0 0 - 1 0 - 1),
          %i(1 1 1 1 0 - - 0 1 -),
          %i(b b b b - b b - a a),
        ])
        outs = Puts.from_columns([
          %i(b b b b - - b a a a),
          %i(- - - - a a - - b b),
        ])
        Function.new(ins: ins, outs: outs)
      end

      let(:g3) do
        ins = Puts.from_columns([
          %i(0 0 - - 1 1 - 0 - -),
          %i(b b b b - - b a a a),
          %i(- - - - a a - - b b),
        ])
        outs = Puts.from_columns([%i(0 0 0 0 0 0 0 1 1 1)])
        Function.new(ins: ins, outs: outs)
      end

      it 'yields decomposed Circuits' do
        wires = Wires.from_array([
          [[g1, :outs, g1.outs, g1.outs[0]],  [h,  :ins, h.ins,  h.ins[3]]],
          [[:circuit, :ins, f.ins, f.ins[4]], [g1, :ins, g1.ins, g1.ins[0]]],
          [[:circuit, :ins, f.ins, f.ins[2]], [g1, :ins, g1.ins, g1.ins[1]]],
          [[:circuit, :ins, f.ins, f.ins[3]], [g1, :ins, g1.ins, g1.ins[2]]],
          [[:circuit, :ins, f.ins, f.ins[0]], [h,  :ins, h.ins,  h.ins[0]]],
          [[:circuit, :ins, f.ins, f.ins[1]], [h,  :ins, h.ins,  h.ins[1]]],
          [[:circuit, :ins, f.ins, f.ins[5]], [h,  :ins, h.ins,  h.ins[2]]],
          [[h, :outs, h.outs, h.outs[0]],
           [:circuit, :outs, f.outs, f.outs[0]]],
        ])
        circuit = Circuit.new(functions: [g1, h], wires: wires)
        FunctionDecomposer::Serial.decompose(f).must_include circuit
      end

      it 'can decompose the largest function further' do
        wires = Wires.from_array([
          [[g2, :outs, g2.outs, g2.outs[0]],  [g3, :ins, g3.ins, g3.ins[1]]],
          [[g2, :outs, g2.outs, g2.outs[1]],  [g3, :ins, g3.ins, g3.ins[2]]],
          [[:circuit, :ins, h.ins, h.ins[0]], [g2, :ins, g2.ins, g2.ins[0]]],
          [[:circuit, :ins, h.ins, h.ins[1]], [g2, :ins, g2.ins, g2.ins[1]]],
          [[:circuit, :ins, h.ins, h.ins[3]], [g2, :ins, g2.ins, g2.ins[2]]],

          [[:circuit, :ins, h.ins, h.ins[2]], [g3, :ins, g3.ins, g3.ins[0]]],
          [[g3, :outs, g3.outs, g3.outs[0]],
           [:circuit, :outs, h.outs, h.outs[0]]],
        ])
        circuit = Circuit.new(functions: [g2, g3], wires: wires)
        FunctionDecomposer::Serial.decompose(h).must_include circuit
      end
    end
  end
end
