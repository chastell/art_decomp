require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit_presenter'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe CircuitPresenter do
    describe '.vhdl_for' do
      let(:bin) do
        KISSParser.circuit_for(File.read('test/fixtures/bin.kiss'))
      end

      it 'returns VHDL for the given Circuit' do
        vhdl = CircuitPresenter.vhdl_for(bin, name: 'bin')
        _(vhdl).must_equal File.read('test/fixtures/bin.vhdl')
      end

      it 'returns VHDL for the given decomposed Circuit' do
        f0 = KISSParser.function_for <<-end
          01- 0
          0-0 0
          000 0
          011 0
          11- 0
          110 0
          001 1
          10- 1
        end
        f1 = KISSParser.function_for <<-end
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
        ins  = f1.ins[0..1] + f0.ins[0..2] + f1.ins[2..2]
        outs = f1.outs[0..0]
        wires = Wires.from_array([
          [[:circuit, ins,     ins[2]],     [f0,       f0.ins, f0.ins[0]]],
          [[:circuit, ins,     ins[3]],     [f0,       f0.ins, f0.ins[1]]],
          [[:circuit, ins,     ins[4]],     [f0,       f0.ins, f0.ins[2]]],
          [[:circuit, ins,     ins[0]],     [f1,       f1.ins, f1.ins[0]]],
          [[:circuit, ins,     ins[1]],     [f1,       f1.ins, f1.ins[1]]],
          [[:circuit, ins,     ins[5]],     [f1,       f1.ins, f1.ins[2]]],
          [[f0,       f0.outs, f0.outs[0]], [f1,       f1.ins, f1.ins[3]]],
          [[f1,       f1.outs, f1.outs[0]], [:circuit, outs,   outs[0]]],
        ])
        bin_decd = bin.with(functions: [f0, f1], wires: wires)
        vhdl = CircuitPresenter.vhdl_for(bin_decd, name: 'bin')
        _(vhdl).must_equal File.read('test/fixtures/bin.decomposed.vhdl')
      end
    end
  end
end
