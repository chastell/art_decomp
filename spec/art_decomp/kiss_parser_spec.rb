require_relative '../spec_helper'

module ArtDecomp describe KISSParser do
  describe '#circuit' do
    it 'returns a Circuit represented by the KISS source' do
      kiss = <<-end.dedent
        .some comments
        0- s1 *  0--
        11 s1 s2 1--
        -0 s3 s1 --0
      end

      is = [{ :'0' => [0,2], :'1' => [1,2] }, { :'0' => [0,2], :'1' => [0,1] }]
      os = [
        { :'0' => [0,2],   :'1' => [1,2]   },
        { :'0' => [0,1,2], :'1' => [0,1,2] },
        { :'0' => [0,1,2], :'1' => [0,1]   },
      ]
      q = { s1: [0,1], s2: [],    s3: [2] }
      p = { s1: [0,2], s2: [0,1], s3: [0] }

      circuit = Object.new
      cf      = MiniTest::Mock.new
      cf.expect :from_fsm, circuit, [{ is: is, q: q, os: os, p: p }]

      KISSParser.new(kiss, circuit_factory: cf).circuit.must_equal circuit

      cf.verify
    end
  end
end end
