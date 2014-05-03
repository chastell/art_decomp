require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'

module ArtDecomp describe B do
  describe '.[]' do
    it 'returns an Integer with the given bits set' do
      B[].must_equal     0b0
      B[0].must_equal    0b1
      B[3,7].must_equal  0b10001000
      B[40].must_equal   2**40
      B[69,1].must_equal 2**69 + 0b10
    end
  end
end end
