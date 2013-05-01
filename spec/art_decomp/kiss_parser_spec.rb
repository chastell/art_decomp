require_relative '../spec_helper'

module ArtDecomp describe KISSParser do
  describe '.circuit_from_kiss' do
    it 'parses the KISS and returns a Circuit' do
      kiss_parser = MiniTest::Mock.new.expect :circuit, circuit = double
      KISSParser.stub :new, kiss_parser do
        KISSParser.circuit_from_kiss('KISS').must_equal circuit
      end
      kiss_parser.verify
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

      is = [Put[:'0' => B[0,2], :'1' => B[1,2]], Put[:'0' => B[0,2], :'1' => B[0,1]]]
      os = [
        Put[:'0' => B[0,2],   :'1' => B[1,2]  ],
        Put[:'0' => B[0,1,2], :'1' => B[0,1,2]],
        Put[:'0' => B[0,1,2], :'1' => B[0,1]  ],
      ]
      qs = [Put[s1: B[0,1], s2: B[],    s3: B[2]]]
      ps = [Put[s1: B[0,2], s2: B[0,1], s3: B[0]]]

      cf = MiniTest::Mock.new
      cf.expect :from_fsm, circuit = double, [{ is: is, qs: qs, os: os, ps: ps }]

      KISSParser.new(kiss).circuit(circuit_factory: cf).must_equal circuit

      cf.verify
    end
  end
end end
