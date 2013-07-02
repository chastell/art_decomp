require_relative '../spec_helper'
require 'tmpdir'

module ArtDecomp describe KISSDecomposer do
  describe '#decompose' do
    it 'decomposes the given KISS file into VHDL implementation' do
      Dir.mktmpdir do |vhdl_path|
        File.stub :read, 'some KISS' do
          decs = fake :decompositions, as: :class,
            for: [fake(:circuit), fake(:circuit)]
          cp     = fake :circuit_presenter, as: :class, vhdl_for: 'some VHDL'
          parser = fake KISSParser, as: :class, circuit_for: fake(:circuit)
          args   = ['--dir', vhdl_path, 'foo/bar/mc.kiss']
          KISSDecomposer.new(args).decompose cp: cp, decs: decs, parser: parser
        end
        File.read("#{vhdl_path}/mc_0.vhdl").must_equal 'some VHDL'
        File.read("#{vhdl_path}/mc_1.vhdl").must_equal 'some VHDL'
      end
    end
  end
end end
