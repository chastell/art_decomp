# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Function do
    let(:function) { Function[ins, outs]           }
    let(:ins)      { Puts[%i(0 1 -), %i(s1 s2 s3)] }
    let(:outs)     { Puts[%i(1 - 0), %i(s3 s1 s2)] }

    describe '.[]' do
      it 'creates a new Function from the given ins and outs' do
        _(Function[ins, outs]).must_equal Function.new(ins: ins, outs: outs)
      end
    end

    describe '#==' do
      it 'compares two Functions by value' do
        assert function == Function[ins, outs]
        refute function == Function[outs, ins]
      end
    end

    describe '#arch' do
      it 'returns the Arch' do
        _(function.arch).must_equal Arch[3, 3]
        _(Function[Puts.new, Puts.new].arch).must_equal Arch[0, 0]
      end
    end

    describe '#ins' do
      it 'returns the Function’s inputs' do
        _(function.ins).must_equal ins
      end
    end

    describe '#outs' do
      it 'returns the Function’s outputs' do
        _(function.outs).must_equal outs
      end
    end

    describe '#size' do
      it 'returns the number of rows' do
        _(function.size).must_equal 3
      end
    end
  end
end
