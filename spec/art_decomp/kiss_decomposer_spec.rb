require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      circuit = Object.new
      decomposer = MiniTest::Mock.new.expect :decompose, circuit, [circuit]

      kiss_parser = MiniTest::Mock.new.expect :circuit, circuit
      kiss_parser_factory = MiniTest::Mock.new
      kiss_parser_factory.expect :new, kiss_parser, ['some KISS']

      circuit_presenter = MiniTest::Mock.new.expect :vhdl, 'some VHDL'
      circuit_presenter_factory = MiniTest::Mock.new
      circuit_presenter_factory.expect :new, circuit_presenter, [circuit]

      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          kiss_decomposer = KISSDecomposer.new decomposer: decomposer,
            circuit_presenter_factory: circuit_presenter_factory,
            kiss_parser_factory: kiss_parser_factory
          kiss_decomposer.decompose ['--dir', vhdl_path, 'foo/bar/mc.kiss']
        end
        File.read("#{vhdl_path}/mc.vhdl").must_equal 'some VHDL'
      end
    end
  end
end end
