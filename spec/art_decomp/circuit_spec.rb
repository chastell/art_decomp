require_relative '../spec_helper'

module ArtDecomp describe Circuit do
  describe '.from_fsm' do
    it 'creates a Circuit representing the FSM' do
      inputs  = [{ :'0' => [0], :'1' => [1] }]
      outputs = [{ :'0' => [1], :'1' => [0] }]
      i_state = { s1: [0], s2: [1], s3: [2] }
      o_state = { s1: [1], s2: [2], s3: [0] }

      function = Object.new
      function_factory = MiniTest::Mock.new.expect :new, function, [inputs + [i_state], outputs + [o_state]]

      circuit = Circuit.from_fsm function_factory: function_factory,
        inputs: inputs, i_state: i_state, outputs: outputs, o_state: o_state
      circuit.functions.must_equal [function]

      function_factory.verify
    end
  end
end end
