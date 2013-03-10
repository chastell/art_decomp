require_relative '../spec_helper'

module ArtDecomp describe KISSParser do
  describe '.circuit_from_kiss' do
    it 'parses the KISS and returns a Circuit' do
      KISSParser.stub :new, double(circuit: circuit = double) do
        KISSParser.circuit_from_kiss('some KISS').must_equal circuit
      end
    end
  end

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

      cf = MiniTest::Mock.new
      cf.expect :from_fsm, circuit = double, [{ is: is, q: q, os: os, p: p }]

      KISSParser.new(kiss).circuit(circuit_factory: cf).must_equal circuit

      cf.verify
    end
  end
end end
