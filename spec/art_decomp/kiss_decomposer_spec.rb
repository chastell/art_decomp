require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          args = ['--dir', vhdl_path, 'foo/bar/mc.kiss']
          kiss_decomposer = KISSDecomposer.new args
          kiss_decomposer.decompose(
            circuit_provider: double(circuit_from_kiss: -> _ { double      }),
            decomposer:       double(decompose:         -> _ { double      }),
            vhdl_provider:    double(vhdl_for_circuit:  -> _ { 'some VHDL' }),
          )
        end
        File.read("#{vhdl_path}/mc.vhdl").must_equal 'some VHDL'
      end
    end
  end
end end
