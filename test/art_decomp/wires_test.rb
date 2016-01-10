require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Wires do
    describe '.from_function' do
      it 'returns a set of Wires from the given Function' do
        i1, i2 = Put[%i(a b)], Put[%i(c d)]
        o1, o2 = Put[%i(e f)], Put[%i(g h)]
        fun    = Function.new(ins: Puts.new([i1, i2]), outs: Puts.new([o1, o2]))
        wires  = { i1 => i1, i2 => i2, o1 => o1, o2 => o2 }
        _(Wires.from_function(fun)).must_equal wires
      end
    end

    describe '#==' do
      it 'compares sets of Wires by value' do
        _(Wires.new(Put[%i(a b)] => Put[%i(c d)]))
          .must_equal Wires.new(Put[%i(a b)] => Put[%i(c d)])
      end
    end
  end
end
