require_relative '../test_helper'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Pin do
    let(:puts) { Puts.from_columns([%i(a b c), %i(c b a)]) }

    describe '.[]' do
      it 'allows for a quick creation of a Pin' do
        pin = Pin.new(object: :circuit, puts: puts, put: puts.first)
        _(Pin[:circuit, puts, puts.first]).must_equal pin
      end
    end

    describe '#bindiwth' do
      it 'returns the binwidth of the Put' do
        _(Pin[:circuit, puts, puts.first].binwidth).must_equal 2
      end
    end

    describe '#circuit?' do
      it 'is a predicate whether this is a circuit pin' do
        function = Function.new(ins: puts, outs: puts)
        assert Pin[:circuit, puts, puts.first].circuit?
        refute Pin[function, puts, puts.first].circuit?
      end
    end

    describe '#offset' do
      it 'returns the offset of the pin from the start' do
        _(Pin[:circuit, puts, puts[1]].offset).must_equal 2
      end
    end
  end
end
