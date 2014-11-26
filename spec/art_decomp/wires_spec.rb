require_relative '../spec_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/wire'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Wires do
    describe '.from_hash' do
      it 'constructs the Wires from a minimal Hash' do
        fun_a, fun_b = fake(:function), fake(:function)
        Wires.from_hash(
          [fun_a, :os, 0] => [fun_b, :is, 1],
          [fun_a, :os, 1] => [fun_b, :is, 0],
        ).must_equal Wires.new([
          Wire[Pin[fun_a, :os, 0], Pin[fun_b, :is, 1]],
          Wire[Pin[fun_a, :os, 1], Pin[fun_b, :is, 0]],
        ])
      end
    end
  end
end
