require_relative '../spec_helper'

module ArtDecomp describe Function do
  describe '#table' do
    it 'contains the truth table' do
      inputs = [
        { :'0' => [0,2], :'1' => [1,2] },
        { :'0' => [0,2], :'1' => [0,1] },
        { s1: [0,1], s2: [], s3: [2]   },
      ]
      outputs = [
        { :'0' => [0,2],   :'1' => [1,2]   },
        { :'0' => [0,1,2], :'1' => [0,1,2] },
        { :'0' => [0,1,2], :'1' => [0,1]   },
        { s1: [0,2], s2: [0,1], s3: [0]    },
      ]
      Function.new(inputs, outputs).table.must_equal [
        [[[0,2], [1,2]], [[0,2], [0,1]], [[0,1], [], [2]]],
        [[[0,2], [1,2]], [[0,1,2], [0,1,2]], [[0,1,2], [0,1]], [[0,2], [0,1], [0]]]
      ]
    end
  end
end end
