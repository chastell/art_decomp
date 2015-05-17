require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'
require_relative 'circuit_behaviour'

module ArtDecomp
  describe Circuit do
    include CircuitBehaviour

    let(:empty) do
      Circuit.new(functions: [], ins: Puts.new, outs: Puts.new,
                  wires: Wires.new)
    end

    describe '.from_puts' do
      it 'creates a Circuit representing the FSM' do
        ins  = Puts.from_columns([%i(0 1)])
        outs = Puts.from_columns([%i(1 0)])
        circuit  = Circuit.from_puts(ins: ins, outs: outs)
        function = Function.new(ins: ins, outs: outs)
        circuit.functions.must_equal [function]
        circuit.wires.must_equal Wires.from_array([
          [[:circuit, :ins,  0], [function, :ins,  0]],
          [[function, :outs, 0], [:circuit, :outs, 0]],
        ])
      end
    end
  end
end
