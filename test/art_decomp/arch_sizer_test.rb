require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/arch_sizer'

module ArtDecomp
  describe ArchSizer do
    describe '#fits?' do
      it 'is a predicate whether a given Arch fits in the implementation' do
        assert ArchSizer.new(Arch[8,8]).fits?
        refute ArchSizer.new(Arch[9,1]).fits?
      end
    end

    describe '#max_quarters' do
      it 'returns the maximum number of quarters of a slice' do
        {
          Arch[0,0]  => 0,
          Arch[0,1]  => 0,
          Arch[1,1]  => 1,
          Arch[5,2]  => 1,
          Arch[5,3]  => 2,
          Arch[6,4]  => 4,
          Arch[7,0]  => 0,
          Arch[7,1]  => 2,
          Arch[7,2]  => 4,
          Arch[8,1]  => 4,
          Arch[8,2]  => 8,
          Arch[9,0]  => 0,
          Arch[9,1]  => 9,
          Arch[9,4]  => 36,
          Arch[14,7] => 1939,
        }.each do |arch, quarters|
          ArchSizer.new(arch).max_quarters.must_equal quarters
        end
      end
    end

    describe '#min_quarters' do
      it 'returns the maximum number of quarters of a slice' do
        {
          Arch[0,0]  => 0,
          Arch[0,1]  => 0,
          Arch[1,0]  => 0,
          Arch[1,1]  => 1,
          Arch[5,2]  => 1,
          Arch[5,3]  => 2,
          Arch[7,0]  => 0,
          Arch[20,8] => 4,
          Arch[21,8] => 5,
          Arch[20,9] => 5,
        }.each do |arch, quarters|
          ArchSizer.new(arch).min_quarters.must_equal quarters
        end
      end
    end
  end
end
