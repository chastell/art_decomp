require 'tmpdir'
require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/circuit_presenter'
require_relative '../../lib/art_decomp/decomposer'
require_relative '../../lib/art_decomp/kiss_decomposer'
require_relative '../../lib/art_decomp/kiss_parser'

module ArtDecomp
  describe KISSDecomposer do
    describe '#decompose' do
      it 'decomposes the given KISS file into VHDL implementation' do
        Dir.mktmpdir do |vhdl_path|
          File.stub(:read, 'some KISS') do
            c1, c2     = fake(Circuit), fake(Circuit)
            decs       = [c1, c2].to_enum
            decomposer = fake(Decomposer, as: :class, decompositions: decs)
            presenter  = fake(CircuitPresenter, as: :class)
            stub(presenter).vhdl_for(c1, name: 'mc_0') { 'VHDL for mc_0' }
            stub(presenter).vhdl_for(c2, name: 'mc_1') { 'VHDL for mc_1' }
            parser   = fake(KISSParser, as: :class, circuit_for: fake(Circuit))
            args     = %W(--dir=#{vhdl_path} foo/bar/mc.kiss)
            kiss_dec = KISSDecomposer.new(args, circuit_presenter: presenter,
                                                decomposer: decomposer,
                                                kiss_parser: parser)
            kiss_dec.decompose
          end
          File.read("#{vhdl_path}/mc_0.vhdl").must_equal 'VHDL for mc_0'
          File.read("#{vhdl_path}/mc_1.vhdl").must_equal 'VHDL for mc_1'
        end
      end
    end
  end
end
