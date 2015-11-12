require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe KISSParser do
    let(:kiss) do
      <<-end.dedent
        .some comments
        0- 0--
        11 1--
        -0 --0
      end
    end

    let(:puts) do
      {
        ins:  Puts.from_columns([%i(0 1 -), %i(- 1 0)]),
        outs: Puts.from_columns([%i(0 1 -), %i(- - -), %i(- - 0)],
                                codes: %i(0 1)),
      }
    end

    describe '.circuit_for' do
      it 'returns a Circuit represented by the KISS source' do
        _(KISSParser.circuit_for(kiss)).must_equal Circuit.from_puts(puts)
      end
    end

    describe '.function_for' do
      it 'returns a Function represented by the KISS source' do
        _(KISSParser.function_for(kiss)).must_equal Function.new(puts)
      end
    end
  end
end
