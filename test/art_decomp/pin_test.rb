require_relative '../test_helper'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Pin do
    let(:puts) { Puts.from_columns([%i(a b c), %i(c b a)]) }

    describe '#bindiwth' do
      it 'returns the binwidth of the Put' do
        _(Pin[:circuit, puts, puts.first].binwidth).must_equal 2
      end
    end

    describe '#offset' do
      it 'returns the offset of the pin from the start' do
        _(Pin[:circuit, puts, puts[1]].offset).must_equal 2
      end
    end
  end
end
