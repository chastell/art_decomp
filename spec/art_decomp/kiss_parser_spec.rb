require_relative '../spec_helper'

module ArtDecomp describe KISSParser do
  fake :circuit

  describe '.circuit_for' do
    it 'parses the KISS and returns a Circuit' do
      mock(kpf = fake).new('KISS') { fake KISSParser, circuit: circuit }
      KISSParser.circuit_for('KISS', kiss_parser_factory: kpf)
        .must_equal circuit
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

      is = [
        Put[:'0' => B[0,2], :'1' => B[1,2]],
        Put[:'0' => B[0,2], :'1' => B[0,1]],
      ]
      os = [
        Put[:'0' => B[0,2],   :'1' => B[1,2]  ],
        Put[:'0' => B[0,1,2], :'1' => B[0,1,2]],
        Put[:'0' => B[0,1,2], :'1' => B[0,1]  ],
      ]
      qs = [Put[s1: B[0,1], s2: B[],    s3: B[2]]]
      ps = [Put[s1: B[0,2], s2: B[0,1], s3: B[0]]]

      cf = fake :circuit, as: :class
      mock(cf).from_fsm(is: is, qs: qs, os: os, ps: ps) { circuit }

      KISSParser.new(kiss).circuit(circuit_factory: cf).must_equal circuit
    end
  end
end end
