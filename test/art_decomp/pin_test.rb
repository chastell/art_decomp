require_relative '../test_helper'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Pin do
    describe '#bindiwth' do
      it 'returns the binwidth of the Put' do
        put = Put[%i(a b c)]
        _(Pin[:circuit, Puts.new(put), put].binwidth).must_equal 2
      end
    end
  end
end
