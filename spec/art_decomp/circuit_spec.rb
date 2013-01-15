require_relative '../spec_helper'

module ArtDecomp describe Circuit do
  describe '.from_fsm' do
    it 'creates a Circuit representing the FSM' do
      inputs = [
        { :'0' => [0,2], :'1' => [1,2] },
        { :'0' => [0,2], :'1' => [0,1] },
      ]
      outputs = [
        { :'0' => [0,2],   :'1' => [1,2]   },
        { :'0' => [0,1,2], :'1' => [0,1,2] },
        { :'0' => [0,1,2], :'1' => [0,1]   },
      ]
      i_state = { s1: [0,1], s2: [],    s3: [2] }
      o_state = { s1: [0,2], s2: [0,1], s3: [0] }

      function = Object.new
      function_factory = MiniTest::Mock.new.expect :new, function, [
        [
          { :'0' => [0,2], :'1' => [1,2] },
          { :'0' => [0,2], :'1' => [0,1] },
          { s1: [0,1], s2: [], s3: [2]   },
        ],
        [
          { :'0' => [0,2],   :'1' => [1,2]   },
          { :'0' => [0,1,2], :'1' => [0,1,2] },
          { :'0' => [0,1,2], :'1' => [0,1]   },
          { s1: [0,2], s2: [0,1], s3: [0]    },
        ],
      ]

      circuit = Circuit.from_fsm function_factory: function_factory,
        inputs: inputs, i_state: i_state, outputs: outputs, o_state: o_state
      circuit.functions.must_equal [function]

      function_factory.verify
    end
  end
end end
