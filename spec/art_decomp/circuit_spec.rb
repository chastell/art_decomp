require_relative '../spec_helper'

module ArtDecomp describe Circuit do
  describe '.from_fsm' do
    it 'creates a Circuit representing the FSM' do
      is = [{ :'0' => [0], :'1' => [1] }]
      os = [{ :'0' => [1], :'1' => [0] }]
      q  = { s1: [0], s2: [1], s3: [2] }
      p  = { s1: [1], s2: [2], s3: [0] }

      function = Object.new
      ff = MiniTest::Mock.new.expect :new, function, [is + [q], os + [p]]

      circuit = Circuit.from_fsm function_factory: ff, is: is, os: os, q: q, p: p

      circuit.functions.must_equal [function]
      ff.verify
    end
  end
end end
