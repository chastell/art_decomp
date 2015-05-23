require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/archs_sizer'

module ArtDecomp
  describe ArchsSizer do
    describe '.adm_size' do
      it 'returns the admissible heuristic size for the given Archs' do
        {
          []                      => 0,
          [Arch[8,1]]             => 1,
          [Arch[7,1], Arch[10,4]] => 1,
          [Arch[8,2]]             => 2,
          [Arch[20,8]]            => 1,
        }.each do |archs, size|
          ArchsSizer.adm_size(archs).must_equal size
        end
      end
    end

    describe '.max_size' do
      it 'returns the maximum size for the given Archs' do
        {
          []                                => 0,
          [Arch[0,0]]                       => 0,
          [Arch[0,1]]                       => 0,
          [Arch[1,1]]                       => 1,
          [Arch[5,2]]                       => 1,
          [Arch[5,3], Arch[5,3], Arch[5,1]] => 2,
          [Arch[5,8]]                       => 1,
          [Arch[5,9]]                       => 2,
          [Arch[6,4]]                       => 1,
          [Arch[6,5]]                       => 2,
          [Arch[7,0]]                       => 0,
          [Arch[7,1], Arch[6,1]]            => 1,
          [Arch[7,2]]                       => 1,
          [Arch[7,3]]                       => 2,
          [Arch[8,1]]                       => 1,
          [Arch[8,2]]                       => 2,
          [Arch[9,0]]                       => 0,
          [Arch[9,1]]                       => 3,
          [Arch[9,4]]                       => 9,
          [Arch[14,7]]                      => 485,
        }.each do |archs, size|
          ArchsSizer.max_size(archs).must_equal size
        end
      end
    end

    describe '.min_size' do
      it 'returns the smallest possible size for the given Archs' do
        {
          []                                => 0,
          [Arch[0,0]]                       => 0,
          [Arch[0,1]]                       => 0,
          [Arch[1,0]]                       => 0,
          [Arch[1,1]]                       => 1,
          [Arch[5,2]]                       => 1,
          [Arch[5,3], Arch[5,3], Arch[5,1]] => 2,
          [Arch[7,0]]                       => 0,
          [Arch[20,8]]                      => 1,
          [Arch[21,8]]                      => 2,
          [Arch[20,9]]                      => 2,
        }.each do |archs, size|
          ArchsSizer.min_size(archs).must_equal size
        end
      end
    end
  end
end
