require_relative '../spec_helper'

module ArtDecomp describe Arch do
  describe '#<=>' do
    it 'makes Archs sortable' do
      a23, a24, a33, a43 = Arch[2,3], Arch[2,4], Arch[3,3], Arch[4,3]
      [a33, a24, a43, a23].sort.must_equal [a23, a24, a33, a43]
    end
  end
end end