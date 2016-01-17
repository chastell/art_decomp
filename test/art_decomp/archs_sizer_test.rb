require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/archs_sizer'

module ArtDecomp
  describe ArchsSizer do
    describe '.admissible' do
      it 'returns the admissible heuristic size for the given Archs' do
        _(ArchsSizer.admissible([])).must_equal 0
        _(ArchsSizer.admissible([Arch[8,1]])).must_equal 1
        _(ArchsSizer.admissible([Arch[7,1], Arch[10,4]])).must_equal 1
        _(ArchsSizer.admissible([Arch[8,2]])).must_equal 2
        _(ArchsSizer.admissible([Arch[20,8]])).must_equal 1
      end
    end

    describe '.max' do
      it 'returns the maximum size for the given Archs' do
        _(ArchsSizer.max([])).must_equal 0
        _(ArchsSizer.max([Arch[0,0]])).must_equal 0
        _(ArchsSizer.max([Arch[0,1]])).must_equal 0
        _(ArchsSizer.max([Arch[1,1]])).must_equal 1
        _(ArchsSizer.max([Arch[5,2]])).must_equal 1
        _(ArchsSizer.max([Arch[5,3], Arch[5,3], Arch[5,1]])).must_equal 2
        _(ArchsSizer.max([Arch[5,8]])).must_equal 1
        _(ArchsSizer.max([Arch[5,9]])).must_equal 2
        _(ArchsSizer.max([Arch[6,4]])).must_equal 1
        _(ArchsSizer.max([Arch[6,5]])).must_equal 2
        _(ArchsSizer.max([Arch[7,0]])).must_equal 0
        _(ArchsSizer.max([Arch[7,1], Arch[6,1]])).must_equal 1
        _(ArchsSizer.max([Arch[7,2]])).must_equal 1
        _(ArchsSizer.max([Arch[7,3]])).must_equal 2
        _(ArchsSizer.max([Arch[8,1]])).must_equal 1
        _(ArchsSizer.max([Arch[8,2]])).must_equal 2
        _(ArchsSizer.max([Arch[9,0]])).must_equal 0
        _(ArchsSizer.max([Arch[9,1]])).must_equal 3
        _(ArchsSizer.max([Arch[9,4]])).must_equal 9
        _(ArchsSizer.max([Arch[14,7]])).must_equal 485
      end
    end

    describe '.min' do
      it 'returns the smallest possible size for the given Archs' do
        _(ArchsSizer.min([])).must_equal 0
        _(ArchsSizer.min([Arch[0,0]])).must_equal 0
        _(ArchsSizer.min([Arch[0,1]])).must_equal 0
        _(ArchsSizer.min([Arch[1,0]])).must_equal 0
        _(ArchsSizer.min([Arch[1,1]])).must_equal 1
        _(ArchsSizer.min([Arch[5,2]])).must_equal 1
        _(ArchsSizer.min([Arch[5,3], Arch[5,3], Arch[5,1]])).must_equal 2
        _(ArchsSizer.min([Arch[7,0]])).must_equal 0
        _(ArchsSizer.min([Arch[20,8]])).must_equal 1
        _(ArchsSizer.min([Arch[21,8]])).must_equal 2
        _(ArchsSizer.min([Arch[20,9]])).must_equal 2
      end
    end
  end
end
