require_relative '../spec_helper'

module ArtDecomp describe Function do
  let(:inputs) {[
    { :'0' => [0,2], :'1' => [1,2] },
    { :'0' => [0,2], :'1' => [0,1] },
    { s1: [0,1], s2: [], s3: [2]   },
  ]}
  let(:outputs) {[
    { :'0' => [0,2],   :'1' => [1,2]   },
    { :'0' => [0,1,2], :'1' => [0,1,2] },
    { :'0' => [0,1,2], :'1' => [0,1]   },
    { s1: [0,2], s2: [0,1], s3: [0]    },
  ]}
  let(:subject) { Function.new inputs, outputs }

  describe '#encodings' do
    it 'contains the encodings' do
      subject.encodings.must_equal [
        [[:'0', :'1'], [:'0', :'1'], [:s1, :s2, :s3]],
        [[:'0', :'1'], [:'0', :'1'], [:'0', :'1'], [:s1, :s2, :s3]]
      ]
    end
  end

  describe '#table' do
    it 'contains the truth table' do
      subject.table.must_equal [
        [[[0,2], [1,2]], [[0,2], [0,1]], [[0,1], [], [2]]],
        [[[0,2], [1,2]], [[0,1,2], [0,1,2]], [[0,1,2], [0,1]], [[0,2], [0,1], [0]]]
      ]
    end
  end
end end
