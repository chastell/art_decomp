require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'

module ArtDecomp
  describe Arch do
    describe '#<=>' do
      it 'makes Archs sortable' do
        a23, a24, a33, a43 = Arch[2,3], Arch[2,4], Arch[3,3], Arch[4,3]
        [a33, a24, a43, a23].sort.must_equal [a23, a24, a33, a43]
      end
    end

    describe '#inspect' do
      it 'returns self-initialising representation' do
        Arch[1,2].inspect.must_equal 'ArtDecomp::Arch[1,2]'
      end
    end
  end
end
