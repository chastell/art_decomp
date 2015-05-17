require_relative '../test_helper'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe KISSParser do
    describe '.circuit_for' do
      it 'returns a Circuit represented by the KISS source' do
        kiss = <<-end.dedent
          .some comments
          0- 0--
          11 1--
          -0 --0
        end

        ins  = Puts.from_columns([%i(0 1 -), %i(- 1 0)])
        outs = Puts.from_columns([%i(0 1 -), %i(- - -), %i(- - 0)])

        circuit = Circuit.from_puts(ins: ins, outs: outs)
        KISSParser.circuit_for(kiss).must_equal circuit
      end
    end
  end
end
