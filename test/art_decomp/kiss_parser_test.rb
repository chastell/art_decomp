# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe KISSParser do
    let(:kiss) do
      <<~end
        .some comments
        0-a 0--
        11b 1--
        -0c --0
      end
    end

    let(:function) do
      Function[Puts[%i[0 1 -], %i[- 1 0], %i[a b c]],
               Puts[%i[0 1 -], %i[- - -], %i[- - 0]]]
    end

    describe '.circuit' do
      it 'returns a Circuit represented by the KISS source' do
        circuit = Circuit.from_function(function)
        _(KISSParser.circuit(kiss)).must_equal circuit
      end
    end

    describe '.function' do
      it 'returns a Function represented by the KISS source' do
        _(KISSParser.function(kiss)).must_equal function
      end
    end
  end
end
