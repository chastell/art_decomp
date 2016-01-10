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
      Circuit.new(archs_sizer: archs_sizer, functions: [], lines: {},
                  own: Function.new(ins: Puts.new, outs: Puts.new),
                  wires: Wires.new)
    end

    describe '.from_function' do
      it 'creates a Circuit representing the FSM' do
        ins  = Puts.from_columns([%i(0 1)])
        outs = Puts.from_columns([%i(1 0)])
        function = Function.new(ins: ins, outs: outs)
        circuit  = Circuit.from_function(function)
        _(circuit.functions).must_equal [function]
        _(circuit.lines).must_equal ins[0] => ins[0], outs[0] => outs[0]
        _(circuit.own).must_equal function
        _(circuit.wires).must_equal Wires.from_array([
          [[:circuit, ins,  ins[0]],  [function, ins,  ins[0]]],
          [[function, outs, outs[0]], [:circuit, outs, outs[0]]],
        ])
      end
    end
  end
end
