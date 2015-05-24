require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wire'

module ArtDecomp
  describe Wire do
    let(:fun_a) do
      Function.new(ins: Puts.new, outs: Puts.from_columns([%i(b a)]))
    end
    let(:fun_b) do
      Function.new(ins: Puts.from_columns([%i(a b c)]), outs: Puts.new)
    end
    let(:wire) { Wire[Pin[fun_a, :outs, 0, 1], Pin[fun_b, :ins, 1, 1]] }

    describe '.from_arrays' do
      it 'constructs the Wire from a minimal Array' do
        from_array = Wire.from_arrays([fun_a, :outs, 0, 1], [fun_b, :ins, 1, 1])
        from_array.must_equal wire
      end
    end

    describe '#inspect' do
      it 'returns self-initialising representation' do
        wire.inspect.must_equal 'ArtDecomp::Wire['                 \
          'ArtDecomp::Pin['                                        \
          'ArtDecomp::Function(ArtDecomp::Arch[0,1]), :outs, 0, 1' \
          ']'                                                      \
          ', '                                                     \
          'ArtDecomp::Pin['                                        \
          'ArtDecomp::Function(ArtDecomp::Arch[2,0]), :ins, 1, 1'  \
          ']'                                                      \
          ']'
      end
    end
  end
end
