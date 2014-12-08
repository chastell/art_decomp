require_relative '../spec_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Function do
    let(:is) do
      Puts.new([Put[:'0' => B[0], :'1' => B[1]],
                Put[s1: B[0], s2: B[1], s3: B[2]]])
    end

    let(:os) do
      Puts.new([Put[:'0' => B[1], :'1' => B[0]],
                Put[s1: B[1], s2: B[2], s3: B[0]]])
    end

    let(:function) { Function.new(is: is, os: os) }

    describe '#==' do
      it 'compares two Functions by value' do
        assert function == Function.new(is: is, os: os)
        refute function == Function.new(is: os, os: is)
      end
    end

    describe '#arch' do
      it 'returns the Arch' do
        function.arch.must_equal Arch[3,3]
        Function.new.arch.must_equal Arch[0,0]
      end
    end

    describe '#is' do
      it 'returns the Function’s inputs' do
        function.is.must_equal is
      end
    end

    describe '#os' do
      it 'returns the Function’s outputs' do
        function.os.must_equal os
      end
    end
  end
end
