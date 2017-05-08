# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Wires do
    let(:ab) { Put[%i[a b]] }
    let(:cd) { Put[%i[c d]] }
    let(:ef) { Put[%i[e f]] }
    let(:gh) { Put[%i[g h]] }

    let(:abcd)      { Wires.new(ab => cd)           }
    let(:efgh)      { Wires.new(ef => gh)           }
    let(:abcd_efgh) { Wires.new(ab => cd, ef => gh) }

    describe '.from_function' do
      it 'returns a set of Wires from the given Function' do
        fun   = Function[Puts.new([ab, cd]), Puts.new([ef, gh])]
        wires = Wires.new(ab => ab, cd => cd, ef => ef, gh => gh)
        _(Wires.from_function(fun)).must_equal wires
      end
    end

    describe '#+' do
      it 'returns a sum of two sets of Wires' do
        _(abcd + efgh).must_equal abcd_efgh
      end
    end

    describe '#==' do
      it 'compares sets of Wires by value' do
        _(abcd).must_equal Wires.new(Put[%i[a b]] => Put[%i[c d]])
      end
    end

    describe '#[]' do
      it 'returns the source Put for the given destination' do
        _(abcd[ab]).must_equal cd
      end
    end

    describe '#invert' do
      it 'inverts the connections' do
        _(abcd.invert).must_equal Wires.new(cd => ab)
      end
    end

    describe '#map' do
      it 'maps subsequent destination-source pairs' do
        _(abcd_efgh.map { |dst, src| [dst.binwidth, src.state?] })
          .must_equal [[1, false], [1, false]]
      end
    end

    describe '#reject' do
      it 'returns an Enumerator when there’s no block' do
        _(abcd.reject).must_be_kind_of Enumerator
      end

      it 'rejects the given wires' do
        _(abcd_efgh.reject { |dst, _src| dst == ab }).must_equal efgh
      end
    end
  end
end
