require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      circuit = double
      decomposer = MiniTest::Mock.new
      decomposer.expect :decompose_circuit, double, [circuit, { width: 7 }]
      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          args = ['--dir', vhdl_path, '--width', '7', 'foo/bar/mc.kiss']
          KISSDecomposer.new(args).decompose(
            circuit_provider: double(circuit_from_kiss: -> _ { circuit }),
            decomposer: decomposer,
            vhdl_provider: double(vhdl_for_circuit: -> _,_ { 'some VHDL' }),
          )
        end
        File.read("#{vhdl_path}/mc.vhdl").must_equal 'some VHDL'
      end
      decomposer.verify
    end
  end
end end
