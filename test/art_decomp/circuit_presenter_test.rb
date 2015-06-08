require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/circuit_presenter'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe CircuitPresenter do
    describe '.vhdl_for' do
      let(:bin) do
        KISSParser.circuit_for(File.read('test/fixtures/bin.kiss'))
      end

      it 'returns VHDL for the given Circuit' do
        vhdl = CircuitPresenter.vhdl_for(bin, name: 'bin')
        vhdl.must_equal File.read('test/fixtures/bin.vhdl')
      end

      it 'returns VHDL for the given decomposed Circuit' do
        f0ins  = Puts.from_columns([%i(0 0 0 0 1 1 0 1),
                                    %i(1 - 0 1 1 1 0 0),
                                    %i(- 0 0 1 - 0 1 -)])
        f0outs = Puts.from_columns([%i(0 0 0 0 0 0 1 1)])
        f1ins  = Puts.from_columns([%i(0 0 - 0 0 - 1 0 - 1),
                                    %i(1 1 1 1 0 - - 0 1 -),
                                    %i(0 0 - - 1 1 - 0 - -),
                                    %i(0 0 0 0 - 0 0 - 1 1)])
        f1outs = Puts.from_columns([%i(0 0 0 0 0 0 0 1 1 1)])
        f0 = Function.new(ins: f0ins, outs: f0outs)
        f1 = Function.new(ins: f1ins, outs: f1outs)
        ins  = f1.ins[0..1] + f0.ins[0..2] + f1.ins[2..2]
        outs = f1.outs[0..0]
        wires = Wires.from_array([
          [[:circuit, :ins, ins, ins[2]],    [f0, :ins, f0.ins, f0.ins[0]]],
          [[:circuit, :ins, ins, ins[3]],    [f0, :ins, f0.ins, f0.ins[1]]],
          [[:circuit, :ins, ins, ins[4]],    [f0, :ins, f0.ins, f0.ins[2]]],
          [[:circuit, :ins, ins, ins[0]],    [f1, :ins, f1.ins, f1.ins[0]]],
          [[:circuit, :ins, ins, ins[1]],    [f1, :ins, f1.ins, f1.ins[1]]],
          [[:circuit, :ins, ins, ins[5]],    [f1, :ins, f1.ins, f1.ins[2]]],
          [[f0, :outs, f0.outs, f0.outs[0]], [f1, :ins, f1.ins, f1.ins[3]]],
          [[f1, :outs, f1.outs, f1.outs[0]], [:circuit, :outs, outs, outs[0]]],
        ])
        bin_decd = bin.update(functions: [f0, f1], wires: wires)
        vhdl = CircuitPresenter.vhdl_for(bin_decd, name: 'bin')
        vhdl.must_equal File.read('test/fixtures/bin.decomposed.vhdl')
      end
    end
  end
end
