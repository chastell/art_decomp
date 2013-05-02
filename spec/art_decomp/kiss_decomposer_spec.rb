require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          args = ['--dir', vhdl_path, 'foo/bar/mc.kiss']
          KISSDecomposer.new(args).decompose(
            circuit_provider: double(circuit_from_kiss: proc { double }),
            decomposer: double(decompositions_for: proc { [double, double] }),
            vhdl_provider: double(vhdl_for_circuit: proc { 'some VHDL' }),
          )
        end
        File.read("#{vhdl_path}/mc.0.vhdl").must_equal 'some VHDL'
        File.read("#{vhdl_path}/mc.1.vhdl").must_equal 'some VHDL'
      end
    end
  end
end end
