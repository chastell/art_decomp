require_relative '../spec_helper'

module ArtDecomp describe Function do
  let(:is) do
    [Put[:'0' => B[0], :'1' => B[1]], Put[s1: B[0], s2: B[1], s3: B[2]]]
  end

  let(:os) do
    [Put[:'0' => B[1], :'1' => B[0]], Put[s1: B[1], s2: B[2], s3: B[0]]]
  end

  let(:function) { Function.new Puts.new is: is, os: os }

  describe '#==' do
    it 'compares two Functions by value' do
      assert function == Function.new(Puts.new is: is, os: os)
      refute function == Function.new(Puts.new is: os, os: is)
    end
  end

  describe '#arch' do
    it 'returns the Arch' do
      function.arch.must_equal Arch[3,3]
      Function.new.arch.must_equal Arch[0,0]
    end
  end

  describe '#binwidths' do
    it 'returns binary widths of the given Puts group' do
      function.binwidths(:is).must_equal [1, 2]
      function.binwidths(:os).must_equal [1, 2]
    end
  end

  describe '#puts' do
    it 'returns the Puts' do
      function.puts.must_equal Puts.new is: is, os: os
    end
  end
end end
