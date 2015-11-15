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
    let(:wire) do
      Wire[Pin[fun_a, :outs, fun_a.outs, fun_a.outs[0]],
           Pin[fun_b, :ins,  fun_b.ins,  fun_b.ins[0]]]
    end

    describe '.from_arrays' do
      it 'constructs the Wire from a minimal Array' do
        fa = Wire.from_arrays(
          [fun_a, :outs, fun_a.outs, fun_a.outs[0]],
          [fun_b, :ins,  fun_b.ins,  fun_b.ins[0]],
        )
        _(fa).must_equal wire
      end
    end
  end
end
