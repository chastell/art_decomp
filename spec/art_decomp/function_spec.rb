require_relative '../spec_helper'

module ArtDecomp describe Function do
  let(:is) { [Put[:'0' => B[0], :'1' => B[1]], Put[s1: B[0], s2: B[1], s3: B[2]]] }
  let(:os) { [Put[:'0' => B[1], :'1' => B[0]], Put[s1: B[1], s2: B[2], s3: B[0]]] }
  let(:function) { Function.new is, os }

  describe '.new' do
    it 'dups the Puts' do
      refute function.is.first.equal? is.first
      refute function.os.last.equal?  os.last
    end
  end

  describe '#arch' do
    it 'returns the Arch' do
      function.arch.must_equal Arch[3,3]
      Function.new.arch.must_equal Arch[0,0]
    end
  end

  describe '#binwidth' do
    it 'returns the binary width' do
      function.binwidth.must_equal 3
      Function.new.binwidth.must_equal 0
    end
  end

  describe '#binwidths' do
    it 'returns binary widths of the given Puts group' do
      function.binwidths(:is).must_equal [1, 2]
      function.binwidths(:os).must_equal [1, 2]
    end
  end

  describe '#is, #os' do
    it 'returns the input/output Puts' do
      function.is.must_equal is
      function.os.must_equal os
    end
  end
end end
