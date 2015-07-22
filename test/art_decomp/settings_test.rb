require_relative '../test_helper'
require_relative '../../lib/art_decomp/settings'

module ArtDecomp
  describe Settings do
    describe '#kiss_path' do
      it 'is set by the first argument' do
        kiss_path = Settings.new(%w(foo/bar/mc.kiss)).kiss_path
        _(kiss_path).must_equal 'foo/bar/mc.kiss'
      end
    end

    describe '#vhdl_path' do
      it 'is parsed from --dir' do
        _(Settings.new(%w(--dir=baz/qux)).vhdl_path).must_equal 'baz/qux'
      end

      it 'is parsed from -d' do
        _(Settings.new(%w(-d baz/qux)).vhdl_path).must_equal 'baz/qux'
      end
    end
  end
end
