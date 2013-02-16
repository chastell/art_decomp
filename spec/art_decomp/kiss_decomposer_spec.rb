require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      circuit           = Object.new
      decomposer        = MiniTest::Mock.new.expect :decompose, circuit, [circuit]
      kiss_parser       = OpenStruct.new circuit: circuit
      circuit_presenter = OpenStruct.new vhdl: 'some VHDL'

      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          kiss_decomposer = KISSDecomposer.new decomposer: decomposer
          kiss_decomposer.decompose ['--dir', vhdl_path, 'foo/bar/mc.kiss'],
            circuit_presenter: circuit_presenter, kiss_parser: kiss_parser
        end
        File.read("#{vhdl_path}/mc.vhdl").must_equal 'some VHDL'
      end
    end
  end
end end
