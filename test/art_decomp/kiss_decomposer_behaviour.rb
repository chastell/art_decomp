require 'tmpdir'
require_relative '../../lib/art_decomp/decomposer'

module ArtDecomp
  module KISSDecomposerBehaviour
    def self.included(spec_class)
      spec_class.class_eval do
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
                parser = fake(:circ_kiss_parser, circuit_for: fake(:circ))
                args   = %W(--dir=#{vhdl_path} baz/bar/foo.kiss)
                decomp = kiss_decomposer.new(args,
                                             circuit_presenter: presenter,
                                             decomposer: decomposer,
                                             kiss_parser: parser)
                decomp.decompose
              end
              File.read("#{vhdl_path}/foo_0.vhdl").must_equal 'VHDL for foo_0'
              File.read("#{vhdl_path}/foo_1.vhdl").must_equal 'VHDL for foo_1'
            end
          end
        end
      end
    end
  end
end
