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
        wires = Wires.from_array([
          [[:circuit, :ins,  2, 1], [f0,       :ins,  0, 1]],
          [[:circuit, :ins,  3, 1], [f0,       :ins,  1, 1]],
          [[:circuit, :ins,  4, 1], [f0,       :ins,  2, 1]],
          [[:circuit, :ins,  0, 1], [f1,       :ins,  0, 1]],
          [[:circuit, :ins,  1, 1], [f1,       :ins,  1, 1]],
          [[:circuit, :ins,  5, 1], [f1,       :ins,  2, 1]],
          [[f0,       :outs, 0, 1], [f1,       :ins,  3, 1]],
          [[f1,       :outs, 0, 1], [:circuit, :outs, 0, 1]],
        ])
        bin_decd = bin.update(functions: [f0, f1], wires: wires)
        vhdl = CircuitPresenter.vhdl_for(bin_decd, name: 'bin')
        vhdl.must_equal File.read('test/fixtures/bin.decomposed.vhdl')
      end
    end
  end
end
