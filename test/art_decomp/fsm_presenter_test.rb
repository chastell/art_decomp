require_relative '../test_helper'
require_relative '../../lib/art_decomp/fsm'
require_relative '../../lib/art_decomp/fsm_presenter'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/fsm_kiss_parser'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe FSMPresenter do
    describe '.vhdl_for' do
      let(:mc) do
        FSMKISSParser.circuit_for(File.read('test/fixtures/mc.kiss'))
      end

      it 'returns VHDL for the given Circuit' do
        vhdl = FSMPresenter.vhdl_for(mc, name: 'mc')
        vhdl.must_equal File.read('test/fixtures/mc.vhdl')
      end

      it 'returns VHDL for the given decomposed Circuit' do
        f0ins  = Puts.from_columns([%i(0 0 0 0 1 1 1 1), %i(0 0 1 1 0 0 1 1)]) +
                 Puts.from_columns([%i(a b a b a b a b)])
        f0outs = Puts.from_columns([%i(b a b a a a b b), %i(a b a b a b a b)])
        f1ins  = Puts.from_columns([%i(- - - - 0 0 0 0 1 1 1 1)]) +
                 Puts.from_columns([%i(a a b b a a b b a a b b),
                                    %i(a b a b a b a b a b a b),
                                    %i(a a a a b b b b b b b b)])
        f1outs = Puts.from_columns([%i(a a b b b b b b a a a a),
                                    %i(a b a b a b a b b a b a)]) +
                 Puts.from_columns([%i(0 0 1 1 0 0 0 0 1 1 1 1),
                                    %i(1 0 1 0 1 0 1 0 1 0 1 0),
                                    %i(0 0 0 0 0 1 0 1 0 1 0 1),
                                    %i(0 1 0 1 0 1 0 1 0 1 0 1),
                                    %i(0 0 0 0 1 0 1 0 1 0 1 0)])
        f0 = Function.new(ins: f0ins, outs: f0outs)
        f1 = Function.new(ins: f1ins, outs: f1outs)
        r_state = Puts.from_columns([%i(FG FY HG HY)])
        r_coded = Puts.from_columns([%i(a b a b), %i(a a b b)])
        r0 = Function.new(ins: r_state, outs: r_coded)
        r1 = Function.new(ins: r_coded, outs: r_state)
        wires = Wires.from_array([
          [[:circuit, :ins,    0, 1, 0], [f0,       :ins,         0, 1, 0]],
          [[:circuit, :ins,    1, 1, 1], [f0,       :ins,         1, 1, 1]],
          [[:circuit, :states, 0, 2, 0], [r0,       :ins,         0, 2, 0]],
          [[r0,       :outs,   1, 1, 1], [f0,       :ins,         2, 1, 2]],
          [[:circuit, :ins,    2, 1, 2], [f1,       :ins,         0, 1, 0]],
          [[f0,       :outs,   0, 1, 0], [f1,       :ins,         1, 1, 1]],
          [[f0,       :outs,   1, 1, 1], [f1,       :ins,         2, 1, 2]],
          [[r0,       :outs,   0, 1, 0], [f1,       :ins,         3, 1, 3]],
          [[r1,       :outs,   0, 2, 0], [:circuit, :next_states, 0, 2, 0]],
          [[f1,       :outs,   0, 1, 0], [r1,       :ins,         0, 1, 0]],
          [[f1,       :outs,   1, 1, 1], [r1,       :ins,         1, 1, 1]],
          [[f1,       :outs,   2, 1, 2], [:circuit, :outs,        0, 1, 0]],
          [[f1,       :outs,   3, 1, 3], [:circuit, :outs,        1, 1, 1]],
          [[f1,       :outs,   4, 1, 4], [:circuit, :outs,        2, 1, 2]],
          [[f1,       :outs,   5, 1, 5], [:circuit, :outs,        3, 1, 3]],
          [[f1,       :outs,   6, 1, 6], [:circuit, :outs,        4, 1, 4]],
        ])
        mc_decd = FSM.new(functions: [f0, f1], ins: mc.ins, outs: mc.outs,
                          states: mc.states, next_states: mc.next_states,
                          recoders: [r0, r1], wires: wires)
        vhdl = FSMPresenter.vhdl_for(mc_decd, name: 'mc')
        vhdl.must_equal File.read('test/fixtures/mc.decomposed.vhdl')
      end
    end
  end
end
