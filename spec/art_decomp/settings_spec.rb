require_relative '../spec_helper'
require_relative '../../lib/art_decomp/settings'

module ArtDecomp
  describe Settings do
    describe '#kiss_path' do
      it 'is set by the first argument' do
        Settings.new(%w(foo/bar/mc.kiss)).kiss_path.must_equal 'foo/bar/mc.kiss'
      end
    end
  end
end
