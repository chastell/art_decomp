require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/arch_sizer'

module ArtDecomp
  describe ArchSizer do
    describe '#fits?' do
      it 'is a predicate whether a given Arch fits in the implementation' do
        assert ArchSizer.new(Arch[8, 8]).fits?
        refute ArchSizer.new(Arch[9, 1]).fits?
      end
    end

    describe '#max_quarters' do
      it 'returns the maximum number of quarters of a slice' do
        _(ArchSizer.new(Arch[0, 0]).max_quarters).must_equal 0
        _(ArchSizer.new(Arch[0, 1]).max_quarters).must_equal 0
        _(ArchSizer.new(Arch[1, 1]).max_quarters).must_equal 1
        _(ArchSizer.new(Arch[5, 2]).max_quarters).must_equal 1
        _(ArchSizer.new(Arch[5, 3]).max_quarters).must_equal 2
        _(ArchSizer.new(Arch[6, 4]).max_quarters).must_equal 4
        _(ArchSizer.new(Arch[7, 0]).max_quarters).must_equal 0
        _(ArchSizer.new(Arch[7, 1]).max_quarters).must_equal 2
        _(ArchSizer.new(Arch[7, 2]).max_quarters).must_equal 4
        _(ArchSizer.new(Arch[8, 1]).max_quarters).must_equal 4
        _(ArchSizer.new(Arch[8, 2]).max_quarters).must_equal 8
        _(ArchSizer.new(Arch[9, 0]).max_quarters).must_equal 0
        _(ArchSizer.new(Arch[9, 1]).max_quarters).must_equal 9
        _(ArchSizer.new(Arch[9, 4]).max_quarters).must_equal 36
        _(ArchSizer.new(Arch[14, 7]).max_quarters).must_equal 1939
      end
    end

    describe '#min_quarters' do
      it 'returns the maximum number of quarters of a slice' do
        _(ArchSizer.new(Arch[0, 0]).min_quarters).must_equal 0
        _(ArchSizer.new(Arch[0, 1]).min_quarters).must_equal 0
        _(ArchSizer.new(Arch[1, 0]).min_quarters).must_equal 0
        _(ArchSizer.new(Arch[1, 1]).min_quarters).must_equal 1
        _(ArchSizer.new(Arch[5, 2]).min_quarters).must_equal 1
        _(ArchSizer.new(Arch[5, 3]).min_quarters).must_equal 2
        _(ArchSizer.new(Arch[7, 0]).min_quarters).must_equal 0
        _(ArchSizer.new(Arch[20, 8]).min_quarters).must_equal 4
        _(ArchSizer.new(Arch[21, 8]).min_quarters).must_equal 5
        _(ArchSizer.new(Arch[20, 9]).min_quarters).must_equal 5
      end
    end
  end
end
