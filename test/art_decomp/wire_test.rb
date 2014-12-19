require_relative '../test_helper'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/wire'

module ArtDecomp
  describe Wire do
    describe '.from_arrays' do
      it 'constructs the Wire from a minimal Array' do
        fun_a = fake(:function)
        fun_b = fake(:function)
        wire = Wire[Pin[fun_a, :os, 0], Pin[fun_b, :is, 1]]
        Wire.from_arrays([fun_a, :os, 0], [fun_b, :is, 1]).must_equal wire
      end
    end

    describe '#inspect' do
      it 'returns self-initialising representation' do
        Wire['src', 'dst'].inspect.must_equal 'ArtDecomp::Wire[src, dst]'
      end
    end
  end
end
