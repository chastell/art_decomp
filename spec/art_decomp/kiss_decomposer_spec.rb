require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      circuit        = Object.new
      decomposer     = MiniTest::Mock.new.expect :decompose,   circuit,     [circuit]
      kiss_parser    = MiniTest::Mock.new.expect :circuit_for, circuit,     ['some KISS']
      vhdl_presenter = MiniTest::Mock.new.expect :vhdl_for,    'some VHDL', [circuit]
      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          kiss_decomposer = KISSDecomposer.new decomposer: decomposer, kiss_parser: kiss_parser, vhdl_presenter: vhdl_presenter
          kiss_decomposer.decompose ['--dir', vhdl_path, 'foo/bar/mc.kiss']
        end
        File.read("#{vhdl_path}/mc.vhdl").must_equal 'some VHDL'
      end
    end
  end
end end
