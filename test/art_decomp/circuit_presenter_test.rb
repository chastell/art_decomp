require_relative '../test_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/circuit_presenter'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe CircuitPresenter do
    describe '.vhdl_for' do
      let(:mc) do
        KISSParser.circuit_for(File.read('test/fixtures/mc.kiss'))
      end

      it 'returns VHDL for the given Circuit' do
        CircuitPresenter.vhdl_for(mc, name: 'mc')
          .must_equal File.read('test/fixtures/mc.vhdl')
      end

      it 'returns VHDL for the given decomposed Circuit' do
        f0ins = Puts.new([
          Put[%i(0 0 0 0 1 1 1 1)],
          Put[%i(0 0 1 1 0 0 1 1)],
          Put[%i(a b a b a b a b)],
        ])
        f0outs = Puts.new([
          Put[%i(b a b a a a b b)],
          Put[%i(a b a b a b a b)],
        ])
        f1ins = Puts.new([
          Put[%i(- - - - 0 0 0 0 1 1 1 1)],
          Put[%i(a a b b a a b b a a b b)],
          Put[%i(a b a b a b a b a b a b)],
          Put[%i(a a a a b b b b b b b b)],
        ])
        f1outs = Puts.new([
          Put[%i(a a b b b b b b a a a a)],
          Put[%i(a b a b a b a b b a b a)],
          Put[%i(0 0 1 1 0 0 0 0 1 1 1 1)],
          Put[%i(1 0 1 0 1 0 1 0 1 0 1 0)],
          Put[%i(0 0 0 0 0 1 0 1 0 1 0 1)],
          Put[%i(0 1 0 1 0 1 0 1 0 1 0 1)],
          Put[%i(0 0 0 0 1 0 1 0 1 0 1 0)],
        ])
        f0 = Function.new(ins: f0ins, outs: f0outs)
        f1 = Function.new(ins: f1ins, outs: f1outs)
        r_state = Puts.new([Put[%i(FG FY HG HY)]])
        r_coded = Puts.new([Put[%i(a b a b)], Put[%i(a a b b)]])
        r0 = Function.new(ins: r_state, outs: r_coded)
        r1 = Function.new(ins: r_coded, outs: r_state)
        wires = Wires.from_array([
          [[:circuit, :ins,  0], [f0,       :ins,         0]],
          [[:circuit, :ins,  1], [f0,       :ins,         1]],
          [[r0,       :outs, 1], [f0,       :ins,         2]],
          [[:circuit, :ins,  2], [f1,       :ins,         0]],
          [[f0,       :outs, 0], [f1,       :ins,         1]],
          [[f0,       :outs, 1], [f1,       :ins,         2]],
          [[r0,       :outs, 0], [f1,       :ins,         3]],
          [[r1,       :outs, 0], [:circuit, :next_states, 0]],
          [[f1,       :outs, 2], [:circuit, :outs,        0]],
          [[f1,       :outs, 3], [:circuit, :outs,        1]],
          [[f1,       :outs, 4], [:circuit, :outs,        2]],
          [[f1,       :outs, 5], [:circuit, :outs,        3]],
          [[f1,       :outs, 6], [:circuit, :outs,        4]],
        ])
        mc_decd = Circuit.new(functions: [f0, f1], ins: mc.ins, outs: mc.outs,
                              states: mc.states, next_states: mc.next_states,
                              recoders: [r0, r1], wires: wires)
        vhdl = File.read('test/fixtures/mc.decomposed.vhdl')
        CircuitPresenter.vhdl_for(mc_decd, name: 'mc').must_equal vhdl
      end
    end
  end
end
