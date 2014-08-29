require 'tmpdir'
require_relative '../spec_helper'
require_relative '../../lib/art_decomp/settings'

module ArtDecomp
  describe Settings do
    describe '#kiss_path' do
      it 'is set by the first argument' do
        Settings.new(%w(foo/bar/mc.kiss)).kiss_path.must_equal 'foo/bar/mc.kiss'
      end
    end

    describe '#vhdl_path' do
      it 'is parsed from --dir' do
        Dir.mktmpdir do |vhdl_path|
          Settings.new(%W(--dir=#{vhdl_path})).vhdl_path.must_equal vhdl_path
        end
      end

      it 'is parsed from -d' do
        Dir.mktmpdir do |vhdl_path|
          Settings.new(%W(-d #{vhdl_path})).vhdl_path.must_equal vhdl_path
        end
      end
    end
  end
end
