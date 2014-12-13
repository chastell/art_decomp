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
  end
end
