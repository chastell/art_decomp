require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          c1, c2     = fake(:circuit), fake(:circuit)
          decomposer = fake :decomposer, decompose_circuit: [c1, c2]
          cp         = fake :circuit_presenter, as: :class
          stub(cp).vhdl_for(c1, 'mc_0') { 'VHDL for mc_0' }
          stub(cp).vhdl_for(c2, 'mc_1') { 'VHDL for mc_1' }
          parser = fake KISSParser, as: :class, circuit_for: fake(:circuit)
          args   = %W[--dir #{vhdl_path} foo/bar/mc.kiss]
          KISSDecomposer.new(args).decompose circuit_presenter: cp,
                                             decomposer: decomposer,
                                             kiss_parser: parser
        end
        File.read("#{vhdl_path}/mc_0.vhdl").must_equal 'VHDL for mc_0'
        File.read("#{vhdl_path}/mc_1.vhdl").must_equal 'VHDL for mc_1'
      end
    end
  end
end end
