require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Function do
    let(:function) { Function.new(ins: ins, outs: outs)           }
    let(:ins)      { Puts.from_columns([%i(0 1 -), %i(s1 s2 s3)]) }
    let(:outs)     { Puts.from_columns([%i(1 - 0), %i(s3 s1 s2)]) }

    describe '#==' do
      it 'compares two Functions by value' do
        assert function == Function.new(ins: ins, outs: outs)
        refute function == Function.new(ins: outs, outs: ins)
      end
    end

    describe '#arch' do
      it 'returns the Arch' do
        _(function.arch).must_equal Arch[3,3]
        _(Function.new(ins: Puts.new, outs: Puts.new).arch).must_equal Arch[0,0]
      end
    end

    describe '#inspect' do
      it 'returns a self-initialising representation' do
        _(function.inspect).must_equal 'ArtDecomp::Function.new('            \
          'ins: '                                                            \
          'ArtDecomp::Puts.new([ArtDecomp::Put[%i(0 1 -), codes: %i(0 1)], ' \
          'ArtDecomp::Put[%i(s1 s2 s3), codes: %i(s1 s2 s3)]]), '            \
          'outs: '                                                           \
          'ArtDecomp::Puts.new([ArtDecomp::Put[%i(1 - 0), codes: %i(0 1)], ' \
          'ArtDecomp::Put[%i(s3 s1 s2), codes: %i(s1 s2 s3)]]))'
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

    describe '#to_s' do
      it 'returns a readable representation' do
        _(function.to_s).must_equal <<-end.dedent
          0 s1 | 1 s3
          1 s2 | - s1
          - s3 | 0 s2
        end
      end
    end
  end
end
