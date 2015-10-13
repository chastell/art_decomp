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

      let(:mc_decd) do
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
        ins  = f0.ins[0..1] + f1.ins[0..0] + r0.ins[0..0]
        outs = f1.outs[2..6] + r1.outs[0..0]
        wires = Wires.from_array([
          [[:circuit, :ins, ins, ins[0]],    [f0, :ins, f0.ins, f0.ins[0]]],
          [[:circuit, :ins, ins, ins[1]],    [f0, :ins, f0.ins, f0.ins[1]]],
          [[:circuit, :ins, ins, ins[3]],    [r0, :ins, r0.ins, r0.ins[0]]],
          [[r0, :outs, r0.outs, r0.outs[1]], [f0, :ins, f0.ins, f0.ins[2]]],
          [[:circuit, :ins, ins, ins[2]],    [f1, :ins, f1.ins, f1.ins[0]]],
          [[f0, :outs, f0.outs, f0.outs[0]], [f1, :ins, f1.ins, f1.ins[1]]],
          [[f0, :outs, f0.outs, f0.outs[1]], [f1, :ins, f1.ins, f1.ins[2]]],
          [[r0, :outs, r0.outs, r0.outs[0]], [f1, :ins, f1.ins, f1.ins[3]]],
          [[r1, :outs, r1.outs, r1.outs[0]], [:circuit, :outs, outs, outs[5]]],
          [[f1, :outs, f1.outs, f1.outs[0]], [r1, :ins, r1.ins, r1.ins[0]]],
          [[f1, :outs, f1.outs, f1.outs[1]], [r1, :ins, r1.ins, r1.ins[1]]],
          [[f1, :outs, f1.outs, f1.outs[2]], [:circuit, :outs, outs, outs[0]]],
          [[f1, :outs, f1.outs, f1.outs[3]], [:circuit, :outs, outs, outs[1]]],
          [[f1, :outs, f1.outs, f1.outs[4]], [:circuit, :outs, outs, outs[2]]],
          [[f1, :outs, f1.outs, f1.outs[5]], [:circuit, :outs, outs, outs[3]]],
          [[f1, :outs, f1.outs, f1.outs[6]], [:circuit, :outs, outs, outs[4]]],
        ])
        FSM.new(functions: [f0, f1], recoders: [r0, r1], wires: wires)
      end

      it 'returns VHDL for the given Circuit' do
        vhdl = FSMPresenter.vhdl_for(mc, name: 'mc')
        _(vhdl).must_equal File.read('test/fixtures/mc.vhdl')
      end

      it 'returns VHDL for the given decomposed Circuit' do
        vhdl = FSMPresenter.vhdl_for(mc_decd, name: 'mc')
        _(vhdl).must_equal File.read('test/fixtures/mc.decomposed.vhdl')
      end
    end
  end
end
