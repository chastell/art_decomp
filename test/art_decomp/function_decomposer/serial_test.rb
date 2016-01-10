require_relative '../../test_helper'
require_relative '../../../lib/art_decomp/circuit'
require_relative '../../../lib/art_decomp/kiss_parser'
require_relative '../../../lib/art_decomp/function_decomposer/serial'

module ArtDecomp                          # rubocop:disable Metrics/ModuleLength
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
        KISSParser.function_for <<-end
          0b- 0
          0b- 0
          -b- 0
          -b- 0
          1-a 0
          1-a 0
          -b- 0
          0a- 1
          -ab 1
          -ab 1
        end
      end

      it 'yields decomposed Circuits' do
        wires = {
          h.ins[0]  => f.ins[0],
          h.ins[1]  => f.ins[1],
          g1.ins[1] => f.ins[2],
          g1.ins[2] => f.ins[3],
          g1.ins[0] => f.ins[4],
          h.ins[2]  => f.ins[5],
          f.outs[0] => h.outs[0],
          h.ins[3]  => g1.outs[0],
        }
        circuit = Circuit.new(functions: [g1, h], own: f, wires: wires)
        _(FunctionDecomposer::Serial.decompose(f)).must_include circuit
      end

      it 'can decompose the largest function further' do
        wires = {
          g2.ins[0] => h.ins[0],
          g2.ins[1] => h.ins[1],
          g3.ins[0] => h.ins[2],
          g2.ins[2] => h.ins[3],
          h.outs[0] => g3.outs[0],
          g3.ins[1] => g2.outs[0],
          g3.ins[2] => g2.outs[1],
        }
        circuit = Circuit.new(functions: [g2, g3], own: h, wires: wires)
        _(FunctionDecomposer::Serial.decompose(h)).must_include circuit
      end
    end
  end
end
