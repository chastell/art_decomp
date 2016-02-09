# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/puts_from_seps'
require_relative '../../lib/art_decomp/seps'

module ArtDecomp
  describe PutsFromSeps do
    describe '.call' do
      it 'creates Puts from the given required and allowed Seps' do
        allowed = Seps.new([0b110110100,
                            0b110111000,
                            0b110111001,
                            0b110110110,
                            0b010001111,
                            0b110001111,
                            0b000000000,
                            0b100111111,
                            0b010101111])
        required = Seps.new([0b010000000,
                             0b010000000,
                             0b110000000,
                             0b010000000,
                             0b000000000,
                             0b110000000,
                             0b000000000,
                             0b000101111,
                             0b000100100])
        puts = PutsFromSeps.call(allowed: allowed, required: required, size: 9)
        _(puts).must_equal Puts[%i(b b b b - b - a a)]
      end

      it 'honours allowed separations' do
        allowed = Seps.new([0b1010,
                            0b0101,
                            0b0010,
                            0b0001])
        required = Seps.new([0b1000,
                             0b0100,
                             0b0010,
                             0b0001])
        puts = PutsFromSeps.call(allowed: allowed, required: required, size: 4)
        _(puts).must_equal Puts[%i(a b a -), %i(a - - b)]
      end
    end
  end
end
