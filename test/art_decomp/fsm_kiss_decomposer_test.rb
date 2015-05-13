require 'tmpdir'
require_relative '../test_helper'
require_relative '../../lib/art_decomp/decomposer'
require_relative '../../lib/art_decomp/fsm_kiss_decomposer'
require_relative '../../lib/art_decomp/fsm_kiss_parser'

module ArtDecomp
  describe FSMKISSDecomposer do
    describe '#decompose' do
      it 'decomposes the given KISS file into VHDL implementation' do
        Dir.mktmpdir do |vhdl_path|
          File.stub(:read, 'some KISS') do
            c1, c2     = fake(:circ), fake(:circ)
            decs       = [c1, c2].to_enum
            decomposer = fake(Decomposer, as: :class, decompositions: decs)
            presenter  = fake(:circuit_presenter, as: :class)
            stub(presenter).vhdl_for(c1, name: 'foo_0') { 'VHDL for foo_0' }
            stub(presenter).vhdl_for(c2, name: 'foo_1') { 'VHDL for foo_1' }
            parser   = fake(FSMKISSParser, as: :class, circuit_for: fake(:circ))
            args     = %W(--dir=#{vhdl_path} baz/bar/foo.kiss)
            kiss_dec = FSMKISSDecomposer.new(args, circuit_presenter: presenter,
                                                   decomposer: decomposer,
                                                   kiss_parser: parser)
            kiss_dec.decompose
          end
          File.read("#{vhdl_path}/foo_0.vhdl").must_equal 'VHDL for foo_0'
          File.read("#{vhdl_path}/foo_1.vhdl").must_equal 'VHDL for foo_1'
        end
      end
    end
  end
end
