require_relative '../spec_helper'

module ArtDecomp describe Function do
  let(:is) { [{ :'0' => [0], :'1' => [1] }, { s1: [0], s2: [1], s3: [2] }] }
  let(:os) { [{ :'0' => [1], :'1' => [0] }, { s1: [1], s2: [2], s3: [0] }] }
  let(:subject) { Function.new is, os }

  describe '#encodings' do
    it 'contains the encodings' do
      subject.encodings.must_equal [
        [[:'0', :'1'], [:s1, :s2, :s3]],
        [[:'0', :'1'], [:s1, :s2, :s3]],
      ]
    end
  end

  describe '#is' do
    it 'returns the input signals' do
      subject.is.must_equal is
    end
  end

  describe '#os' do
    it 'returns the input signals' do
      subject.os.must_equal os
    end
  end

  describe '#table' do
    it 'contains the truth table' do
      subject.table.must_equal [
        [[[0], [1]], [[0], [1], [2]]],
        [[[1], [0]], [[1], [2], [0]]],
      ]
    end
  end

  describe '#widths' do
    it 'returns binary widths of signals' do
      subject.widths(:i).must_equal [1, 2]
      subject.widths(:o).must_equal [1, 2]
    end
  end
end end
