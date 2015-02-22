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
          Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]],
          Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]],
          Put[a: B[0,2,4,6], b: B[1,3,5,7]],
        ])
        f0outs = Puts.new([
          Put[a: B[1,3,4,5], b: B[0,2,6,7]],
          Put[a: B[0,2,4,6], b: B[1,3,5,7]],
        ])
        f1ins = Puts.new([
          Put[:'0' => B[0,1,2,3,4,5,6,7], :'1' => B[0,1,2,3,8,9,10,11]],
          Put[a: B[0,1,4,5,8,9], b: B[2,3,6,7,10,11]],
          Put[a: B[0,2,4,6,8,10], b: B[1,3,5,7,9,11]],
          Put[a: B[0,1,2,3], b: B[4,5,6,7,8,9,10,11]],
        ])
        f1outs = Puts.new([
          Put[a: B[0,1,8,9,10,11], b: B[2,3,4,5,6,7]],
          Put[a: B[0,2,4,6,9,11], b: B[1,3,5,7,8,10]],
          Put[:'0' => B[0,1,4,5,6,7], :'1' => B[2,3,8,9,10,11]],
          Put[:'0' => B[1,3,5,7,9,11], :'1' => B[0,2,4,6,8,10]],
          Put[:'0' => B[0,1,2,3,4,6,8,10], :'1' => B[5,7,9,11]],
          Put[:'0' => B[0,2,4,6,8,10], :'1' => B[1,3,5,7,9,11]],
          Put[:'0' => B[0,1,2,3,5,7,9,11], :'1' => B[4,6,8,10]],
        ])
        f0 = Function.new(ins: f0ins, outs: f0outs)
        f1 = Function.new(ins: f1ins, outs: f1outs)
        r_state = Puts.new([Put[FG: B[0], FY: B[1], HG: B[2], HY: B[3]]])
        r_coded = Puts.new([Put[a: B[0,2], b: B[1,3]],
                            Put[a: B[0,1], b: B[2,3]]])
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
