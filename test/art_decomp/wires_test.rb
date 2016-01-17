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
        fun    = Function[Puts.new([ab, cd]), Puts.new([ef, gh])]
        wires  = Wires.new(ab => ab, cd => cd, ef => ef, gh => gh)
        _(Wires.from_function(fun)).must_equal wires
      end
    end

    describe '#+' do
      it 'returns a sum of two sets of Wires' do
        abcd_plus_efgh = Wires.new(ab => cd) + Wires.new(ef => gh)
        _(abcd_plus_efgh).must_equal Wires.new(ab => cd, ef => gh)
      end
    end

    describe '#==' do
      it 'compares sets of Wires by value' do
        abcd = Wires.new(ab => cd)
        _(abcd).must_equal Wires.new(Put[%i(a b)] => Put[%i(c d)])
      end
    end

    describe '#[]' do
      it 'returns the source Put for the given destination' do
        _(Wires.new(ab => cd)[ab]).must_equal cd
      end
    end

    describe '#invert' do
      it 'inverts the connections' do
        _(Wires.new(ab => cd).invert).must_equal Wires.new(cd => ab)
      end
    end

    describe '#map' do
      it 'maps subsequent destination-source pairs' do
        wires = Wires.new(ab => cd, ef => gh)
        _(wires.map { |dst, src| [dst.binwidth, src.state?] })
          .must_equal [[1, false], [1, false]]
      end
    end

    describe '#reject' do
      it 'returns an Enumerator when there’s no block' do
        _(Wires.new(ab => cd).reject).must_be_kind_of Enumerator
      end

      it 'rejects the given wires' do
        wires = Wires.new(ab => cd, ef => gh)
        _(wires.reject { |dst, _src| dst == ab }).must_equal Wires.new(ef => gh)
      end
    end
  end
end
