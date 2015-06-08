require_relative '../test_helper'
require_relative '../../lib/art_decomp/fsm'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/state_put'
require_relative '../../lib/art_decomp/wires'
require_relative 'circuit_behaviour'

module ArtDecomp
  describe FSM do
    include CircuitBehaviour

    let(:empty) do
      FSM.new(functions: [], recoders: [], wires: Wires.new)
    end

    describe '.from_puts' do
      it 'creates an FSM from Puts' do
        ins  = Puts.new([Put[%i(0 1)], StatePut[%i(s1 s2 s3)]])
        outs = Puts.new([Put[%i(1 0)], StatePut[%i(s3 s1 s2)]])
        fsm  = FSM.from_puts(ins: ins, outs: outs)
        function = Function.new(ins: ins, outs: outs)
        fsm.functions.must_equal [function]
        fsm.recoders.must_be :empty?
        fsm.wires.must_equal Wires.from_array([
          [[:circuit, :ins,         ins,  ins[0],  0, 1, 0],
           [function, :ins,         ins,  ins[0],  0, 1, 0]],
          [[:circuit, :states,      ins,  ins[1],  0, 2, 0],
           [function, :ins,         ins,  ins[1],  1, 2, 1]],
          [[function, :outs,        outs, outs[0], 0, 1, 0],
           [:circuit, :outs,        outs, outs[0], 0, 1, 0]],
          [[function, :outs,        outs, outs[1], 1, 2, 1],
           [:circuit, :next_states, outs, outs[1], 0, 2, 0]],
        ])
      end
    end

    describe '#recoders' do
      it 'gets the Recorders' do
        empty.update(recoders: recs = fake(Array)).recoders.must_equal recs
      end
    end
  end
end
