require_relative '../test_helper'
require_relative '../../lib/art_decomp/kiss_parser'
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

        ins  = Puts.from_columns([%i(0 1 -), %i(- 1 0)])
        outs = Puts.from_columns([%i(0 1 -), %i(- - -), %i(- - 0)])
        states      = Puts.from_columns([%i(s1 s1 s3)], codes: %i(s1 s2 s3))
        next_states = Puts.from_columns([%i(-  s2 s1)], codes: %i(s1 s2 s3))

        circuit = Circuit.from_fsm(ins: ins, outs: outs, states: states,
                                   next_states: next_states)
        KISSParser.circuit_for(kiss).must_equal circuit
      end
    end
  end
end
