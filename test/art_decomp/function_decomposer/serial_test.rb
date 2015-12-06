require_relative '../../test_helper'
require_relative '../../../lib/art_decomp/circuit'
require_relative '../../../lib/art_decomp/kiss_parser'
require_relative '../../../lib/art_decomp/function'
require_relative '../../../lib/art_decomp/function_decomposer/serial'
require_relative '../../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionDecomposer::Serial do
    describe '.decompose' do
      let(:f) do
        KISSParser.function_for <<-end
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
      end

      let(:g1) do
        KISSParser.function_for <<-end
          -01 b
          00- b
          000 b
          101 b
          -1- -
          -11 b
          011 b
          --- -
          100 a
          -10 a
        end
      end

      let(:h) do
        KISSParser.function_for <<-end
          010b 0
          010b 0
          -1-b 0
          01-b 0
          001- 0
          --1b 0
          1--b 0
          000- 1
          -1-a 1
          1--a 1
        end
      end

      let(:g2) do
        KISSParser.function_for <<-end
          01b b-
          01b b-
          -1b b-
          01b b-
          00- -a
          --b -a
          1-b b-
          00- a-
          -1a ab
          1-a ab
        end
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
          [[g1,       g1.outs, g1.outs[0]], [h,        h.ins,  h.ins[3]]],
          [[:circuit, f.ins,   f.ins[4]],   [g1,       g1.ins, g1.ins[0]]],
          [[:circuit, f.ins,   f.ins[2]],   [g1,       g1.ins, g1.ins[1]]],
          [[:circuit, f.ins,   f.ins[3]],   [g1,       g1.ins, g1.ins[2]]],
          [[:circuit, f.ins,   f.ins[0]],   [h,        h.ins,  h.ins[0]]],
          [[:circuit, f.ins,   f.ins[1]],   [h,        h.ins,  h.ins[1]]],
          [[:circuit, f.ins,   f.ins[5]],   [h,        h.ins,  h.ins[2]]],
          [[h,        h.outs,  h.outs[0]],  [:circuit, f.outs, f.outs[0]]],
        ])
        circuit = Circuit.new(functions: [g1, h], wires: wires)
        _(FunctionDecomposer::Serial.decompose(f)).must_include circuit
      end

      it 'can decompose the largest function further' do
        wires = Wires.from_array([
          [[g2,       g2.outs, g2.outs[0]], [g3,       g3.ins, g3.ins[1]]],
          [[g2,       g2.outs, g2.outs[1]], [g3,       g3.ins, g3.ins[2]]],
          [[:circuit, h.ins,   h.ins[0]],   [g2,       g2.ins, g2.ins[0]]],
          [[:circuit, h.ins,   h.ins[1]],   [g2,       g2.ins, g2.ins[1]]],
          [[:circuit, h.ins,   h.ins[3]],   [g2,       g2.ins, g2.ins[2]]],
          [[:circuit, h.ins,   h.ins[2]],   [g3,       g3.ins, g3.ins[0]]],
          [[g3,       g3.outs, g3.outs[0]], [:circuit, h.outs, h.outs[0]]],
        ])
        circuit = Circuit.new(functions: [g2, g3], wires: wires)
        _(FunctionDecomposer::Serial.decompose(h)).must_include circuit
      end
    end
  end
end
