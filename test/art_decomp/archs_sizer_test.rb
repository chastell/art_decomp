require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/archs_sizer'

module ArtDecomp
  describe ArchsSizer do
    describe '.adm_size' do
      it 'returns the admissible heuristic size for the given Archs' do
        ArchsSizer.adm_size([]).must_equal 0
        ArchsSizer.adm_size([Arch[8,1]]).must_equal 1
        ArchsSizer.adm_size([Arch[7,1], Arch[10,4]]).must_equal 1
        ArchsSizer.adm_size([Arch[8,2]]).must_equal 2
        ArchsSizer.adm_size([Arch[20,8]]).must_equal 1
      end
    end

    describe '.max_size' do
      it 'returns the maximum size for the given Archs' do
        ArchsSizer.max_size([]).must_equal 0
        ArchsSizer.max_size([Arch[0,0]]).must_equal 0
        ArchsSizer.max_size([Arch[0,1]]).must_equal 0
        ArchsSizer.max_size([Arch[1,1]]).must_equal 1
        ArchsSizer.max_size([Arch[5,2]]).must_equal 1
        ArchsSizer.max_size([Arch[5,3], Arch[5,3], Arch[5,1]]).must_equal 2
        ArchsSizer.max_size([Arch[5,8]]).must_equal 1
        ArchsSizer.max_size([Arch[5,9]]).must_equal 2
        ArchsSizer.max_size([Arch[6,4]]).must_equal 1
        ArchsSizer.max_size([Arch[6,5]]).must_equal 2
        ArchsSizer.max_size([Arch[7,0]]).must_equal 0
        ArchsSizer.max_size([Arch[7,1], Arch[6,1]]).must_equal 1
        ArchsSizer.max_size([Arch[7,2]]).must_equal 1
        ArchsSizer.max_size([Arch[7,3]]).must_equal 2
        ArchsSizer.max_size([Arch[8,1]]).must_equal 1
        ArchsSizer.max_size([Arch[8,2]]).must_equal 2
        ArchsSizer.max_size([Arch[9,0]]).must_equal 0
        ArchsSizer.max_size([Arch[9,1]]).must_equal 3
        ArchsSizer.max_size([Arch[9,4]]).must_equal 9
        ArchsSizer.max_size([Arch[14,7]]).must_equal 485
      end
    end

    describe '.min_size' do
      it 'returns the smallest possible size for the given Archs' do
        ArchsSizer.min_size([]).must_equal 0
        ArchsSizer.min_size([Arch[0,0]]).must_equal 0
        ArchsSizer.min_size([Arch[0,1]]).must_equal 0
        ArchsSizer.min_size([Arch[1,0]]).must_equal 0
        ArchsSizer.min_size([Arch[1,1]]).must_equal 1
        ArchsSizer.min_size([Arch[5,2]]).must_equal 1
        ArchsSizer.min_size([Arch[5,3], Arch[5,3], Arch[5,1]]).must_equal 2
        ArchsSizer.min_size([Arch[7,0]]).must_equal 0
        ArchsSizer.min_size([Arch[20,8]]).must_equal 1
        ArchsSizer.min_size([Arch[21,8]]).must_equal 2
        ArchsSizer.min_size([Arch[20,9]]).must_equal 2
      end
    end
  end
end
