require_relative '../spec_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/arch_sizer'

module ArtDecomp describe ArchSizer do
  describe '#fits?' do
    it 'is a predicate whether a given Arch fits in the implementation' do
      assert ArchSizer.new(Arch[8,8]).fits?
      refute ArchSizer.new(Arch[9,1]).fits?
    end
  end
end end
