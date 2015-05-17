require_relative '../test_helper'
require_relative '../../lib/art_decomp/fsm'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'
require_relative 'circuit_behaviour'

module ArtDecomp
  describe FSM do
    include CircuitBehaviour

    let(:empty) do
      FSM.new(functions: [], ins: Puts.new, outs: Puts.new,
              states: Puts.new, next_states: Puts.new, recoders: [],
              wires: Wires.new)
    end

    describe '.from_puts' do
      it 'creates an FSM from Puts' do
        ins  = Puts.from_columns([%i(0 1)])
        outs = Puts.from_columns([%i(1 0)])
        states      = Puts.from_columns([%i(s1 s2 s3)])
        next_states = Puts.from_columns([%i(s3 s1 s2)])
        fsm  = FSM.from_puts(ins: ins, outs: outs, states: states,
                             next_states: next_states)
        function = Function.new(ins: ins + states, outs: outs + next_states)
        fsm.functions.must_equal [function]
        fsm.recoders.must_be :empty?
        fsm.wires.must_equal Wires.from_array([
          [[:circuit, :ins,    0], [function, :ins,         0]],
          [[:circuit, :states, 0], [function, :ins,         1]],
          [[function, :outs,   0], [:circuit, :outs,        0]],
          [[function, :outs,   1], [:circuit, :next_states, 0]],
        ])
      end
    end

    describe '#states, #next_states' do
      it 'returns the FSM’s Put groups' do
        %i(states next_states).each do |type|
          puts = Puts.new([stub(:put)])
          empty.update(type => puts).send(type).must_equal puts
        end
      end
    end

    describe '#recoders' do
      it 'gets the Recorders' do
        empty.update(recoders: recs = fake(Array)).recoders.must_equal recs
      end
    end
  end
end
