# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/fsm_kiss_parser'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/state_put'

module ArtDecomp
  describe FSMKISSParser do
    describe '.circuit_for' do
      it 'returns a Circuit represented by the KISS source' do
        kiss = <<~end
          .some comments
          0- s1 *  0--
          11 s1 s2 1--
          -0 s3 s1 --0
        end
        ins  = Puts[%i(0 1 -), %i(- 1 0)] +
               Puts.new([StatePut[%i(s1 s1 s3), codes: %i(s1 s2 s3)]])
        outs = Puts[%i(0 1 -), %i(- - -), %i(- - 0)] +
               Puts.new([StatePut[%i(-  s2 s1), codes: %i(s1 s2 s3)]])
        circ = Circuit.from_function(Function[ins, outs])
        _(FSMKISSParser.circuit_for(kiss)).must_equal circ
      end
    end
  end
end
