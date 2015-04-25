require_relative '../test_helper'
require_relative '../../lib/art_decomp/b'

module ArtDecomp
  describe B do
    describe '.[]' do
      it 'returns an Integer with the given bits set' do
        {
          B[]     => 0b0,
          B[0]    => 0b1,
          B[3,7]  => 0b10001000,
          B[40]   => 2**40,
          B[69,1] => 2**69 + 0b10,
        }.each do |block, number|
          block.must_equal number
        end
      end
    end
  end
end
