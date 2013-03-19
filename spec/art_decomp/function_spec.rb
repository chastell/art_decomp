require_relative '../spec_helper'

module ArtDecomp describe Function do
  let(:is) { [{ :'0' => [0], :'1' => [1] }, { s1: [0], s2: [1], s3: [2] }] }
  let(:os) { [{ :'0' => [1], :'1' => [0] }, { s1: [1], s2: [2], s3: [0] }] }
  let(:function) { Function.new is, os }

  describe '#is' do
    it 'returns the input signals' do
      function.is.must_equal is
    end
  end

  describe '#os' do
    it 'returns the input signals' do
      function.os.must_equal os
    end
  end

  describe '#width' do
    it 'returns binary width of the function' do
      Function.new([], []).width.must_equal 0
      function.width.must_equal 3
    end
  end

  describe '#widths' do
    it 'returns binary widths of signals' do
      function.widths(:i).must_equal [1, 2]
      function.widths(:o).must_equal [1, 2]
    end
  end
end end
