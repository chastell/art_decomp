require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Puts do
    let(:a0b1) { Put[a: B[0], b: B[1]] }
    let(:a1b0) { Put[a: B[1], b: B[0]] }

    describe '#==' do
      it 'compares Puts according to contents' do
        Puts.new([a0b1]).must_equal Puts.new([a0b1])
        Puts.new([a0b1]).wont_equal Puts.new([a1b0])
      end
    end

    describe '#&' do
      it 'creates an intersection of Puts' do
        (Puts.new([a0b1, a1b0]) & Puts.new([a0b1])).must_equal Puts.new([a0b1])
        (Puts.new([a0b1, a1b0]) & Puts.new([a1b0])).must_equal Puts.new([a1b0])
      end
    end

    describe '#+' do
      it 'creates a sum of Puts' do
        (Puts.new([a0b1]) + Puts.new([a1b0])).must_equal Puts.new([a0b1, a1b0])
      end
    end

    describe '#[]' do
      it 'returns the Put at the given index' do
        Puts.new([a0b1, a1b0])[0].must_equal a0b1
        Puts.new([a0b1, a1b0])[1].must_equal a1b0
      end
    end

    describe '#binwidth' do
      it 'returns the binwidth of all the Puts combined' do
        Puts.new.binwidth.must_equal 0
        Puts.new([a0b1]).binwidth.must_equal 1
        Puts.new([a1b0, Put[a: B[0], b: B[1], c: B[2]]]).binwidth.must_equal 3
      end
    end

    describe '#each' do
      it 'yields subsequent Puts' do
        Puts.new([a0b1, a1b0]).each.with_object([]) { |put, ary| ary << put }
          .must_equal [a0b1, a1b0]
      end
    end

    describe '#empty?' do
      it 'is a predicate whether the Puts are empty' do
        assert Puts.new.empty?
        refute Puts.new([a0b1]).empty?
      end
    end
  end
end
