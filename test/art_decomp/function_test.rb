require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Function do
    let(:ins) do
      Puts.new([Put[:'0' => B[0], :'1' => B[1]],
                Put[s1: B[0], s2: B[1], s3: B[2]]])
    end

    let(:outs) do
      Puts.new([Put[:'0' => B[1], :'1' => B[0]],
                Put[s1: B[1], s2: B[2], s3: B[0]]])
    end

    let(:function) { Function.new(ins: ins, outs: outs) }

    describe '#==' do
      it 'compares two Functions by value' do
        assert function == Function.new(ins: ins, outs: outs)
        refute function == Function.new(ins: outs, outs: ins)
      end
    end

    describe '#arch' do
      it 'returns the Arch' do
        function.arch.must_equal Arch[3,3]
        Function.new.arch.must_equal Arch[0,0]
      end
    end

    describe '#inspect' do
      it 'returns a readable representation' do
        function.inspect.must_equal 'ArtDecomp::Function(ArtDecomp::Arch[3,3])'
      end
    end

    describe '#ins' do
      it 'returns the Function’s inputs' do
        function.ins.must_equal ins
      end
    end

    describe '#outs' do
      it 'returns the Function’s outputs' do
        function.outs.must_equal outs
      end
    end
  end
end
