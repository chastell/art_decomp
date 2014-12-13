require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Puts do
    describe '#==' do
      it 'compares Puts according to contents' do
        Puts.new([Put[a: 0, b: 1]]).must_equal Puts.new([Put[a: 0, b: 1]])
        Puts.new([Put[a: 0, b: 1]]).wont_equal Puts.new([Put[a: 1, b: 0]])
      end
    end
  end
end
