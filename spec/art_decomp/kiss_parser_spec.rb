require_relative '../spec_helper'

module ArtDecomp describe KISSParser do
  describe '#circuit_for' do
    it 'returns a Circuit represented by the KISS source' do
      kiss = <<-end.dedent
        .i 3
        .o 5
        .p 10
        .s 4
        0-- HG HG 00010
        -0- HG HG 00010
        11- HG HY 10010
        --0 HY HY 00110
        --1 HY FG 10110
        10- FG FG 01000
        0-- FG FY 11000
        -1- FG FY 11000
        --0 FY FY 01001
        --1 FY HG 11001
      end
      inputs = [
        { :'0' => [0,1,3,4,6,7,8,9], :'1' => [1,2,3,4,5,7,8,9] },
        { :'0' => [0,1,3,4,5,6,8,9], :'1' => [0,2,3,4,6,7,8,9] },
        { :'0' => [0,1,2,3,5,6,7,8], :'1' => [0,1,2,4,5,6,7,9] },
      ]
      outputs = [
        { :'0' => [0,1,3,5,8], :'1' => [2,4,6,7,9] },
        { :'0' => [0,1,2,3,4], :'1' => [5,6,7,8,9] },
        { :'0' => [0,1,2,5,6,7,8,9], :'1' => [3,4] },
        { :'1' => [0,1,2,3,4], :'0' => [5,6,7,8,9] },
        { :'0' => [0,1,2,3,4,5,6,7], :'1' => [8,9] },
      ]
      i_state = { HG: [0,1,2], HY: [3,4], FG: [5,6,7], FY: [8,9] }
      o_state = { HG: [0,1,9], HY: [2,3], FG: [4,5], FY: [6,7,8] }
      circuit         = Object.new
      circuit_factory = MiniTest::Mock.new
      circuit_factory.expect :from_fsm, circuit, [{ inputs: inputs, i_state: i_state, outputs: outputs, o_state: o_state }]

      result = KISSParser.new(kiss, circuit_factory: circuit_factory).circuit

      result.must_equal circuit
      circuit_factory.verify
    end
  end
end end
