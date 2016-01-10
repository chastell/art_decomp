require 'tmpdir'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/decomposer'

module ArtDecomp
  module KISSDecomposerBehaviour
    def self.included(spec_class)
      spec_class.class_eval do
        describe '#decompose' do
          it 'decomposes the given KISS file into VHDL implementation' do
            Dir.mktmpdir do |vhdl_path|
              File.stub(:read, 'some KISS') do
                c1, c2     = fake(Circuit), fake(Circuit)
                decs       = [c1, c2].to_enum
                decomposer = fake(Decomposer, as: :class, decompositions: decs)
                presenter  = fake(:circuit_presenter, as: :class)
                stub(presenter).vhdl_for(c1, name: 'foo_0') { 'foo_0 VHDL' }
                stub(presenter).vhdl_for(c2, name: 'foo_1') { 'foo_1 VHDL' }
                parser = fake(:circ_kiss_parser, circuit_for: fake(Circuit))
                args   = %W(--dir=#{vhdl_path} baz/bar/foo.kiss)
                decomp = kiss_decomposer.new(args,
                                             circuit_presenter: presenter,
                                             decomposer: decomposer,
                                             kiss_parser: parser)
                decomp.decompose
              end
              _(File.read("#{vhdl_path}/foo_0.vhdl")).must_equal 'foo_0 VHDL'
              _(File.read("#{vhdl_path}/foo_1.vhdl")).must_equal 'foo_1 VHDL'
            end
          end
        end
      end
    end
  end
end
