require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe KISSParser do
    describe '.circuit_for' do
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
          Put[:'0' => B[0,2],   :'1' => B[1,2]],
          Put[:'0' => B[0,1,2], :'1' => B[0,1,2]],
          Put[:'0' => B[0,1,2], :'1' => B[0,1]],
        ]
        qs = [Put[s1: B[0,1], s2: B[],    s3: B[2]]]
        ps = [Put[s1: B[0,2], s2: B[0,1], s3: B[0]]]

        circuit = Circuit.from_fsm(Puts.new(is: is, qs: qs, os: os, ps: ps))
        KISSParser.circuit_for(kiss).must_equal circuit
      end
    end
  end
end
