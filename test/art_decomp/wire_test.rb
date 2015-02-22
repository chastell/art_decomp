require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wire'

module ArtDecomp
  describe Wire do
    let(:fun_a) do
      Function.new(ins: Puts.new, outs: Puts.new([Put[a: 1, b: 0]]))
    end
    let(:fun_b) do
      Function.new(ins: Puts.new([Put[a: 0, b: 1, c: 2]]), outs: Puts.new)
    end
    let(:wire) { Wire[Pin[fun_a, :outs, 0], Pin[fun_b, :ins, 1]] }

    describe '.from_arrays' do
      it 'constructs the Wire from a minimal Array' do
        Wire.from_arrays([fun_a, :outs, 0], [fun_b, :ins, 1]).must_equal wire
      end
    end

    describe '#inspect' do
      it 'returns self-initialising representation' do
        wire.inspect.must_equal 'ArtDecomp::Wire['                             \
          'ArtDecomp::Pin[ArtDecomp::Function(ArtDecomp::Arch[0,1]), :outs, 0]'\
          ', '                                                                 \
          'ArtDecomp::Pin[ArtDecomp::Function(ArtDecomp::Arch[2,0]), :ins, 1]' \
          ']'
      end
    end
  end
end
