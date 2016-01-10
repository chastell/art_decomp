require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Wires do
    let(:ab) { Put[%i(a b)] }
    let(:cd) { Put[%i(c d)] }
    let(:ef) { Put[%i(e f)] }
    let(:gh) { Put[%i(g h)] }

    describe '.from_function' do
      it 'returns a set of Wires from the given Function' do
        fun    = Function.new(ins: Puts.new([ab, cd]), outs: Puts.new([ef, gh]))
        wires  = Wires.new(ab => ab, cd => cd, ef => ef, gh => gh)
        _(Wires.from_function(fun)).must_equal wires
      end
    end

    describe '#==' do
      it 'compares sets of Wires by value' do
        abcd = Wires.new(ab => cd)
        _(abcd).must_equal Wires.new(Put[%i(a b)] => Put[%i(c d)])
      end
    end
  end
end
