require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          args = ['--dir', vhdl_path, 'foo/bar/mc.kiss']
          KISSDecomposer.new(args).decompose(
            cp: double(vhdl_for: proc { |_, name| "some VHDL for #{name}" }),
            decs: double(for: proc { [double, double] }),
            parser: double(circuit_for: proc { double }),
          )
        end
        File.read("#{vhdl_path}/mc_0.vhdl").must_equal 'some VHDL for mc_0'
        File.read("#{vhdl_path}/mc_1.vhdl").must_equal 'some VHDL for mc_1'
      end
    end
  end
end end
