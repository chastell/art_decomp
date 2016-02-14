# frozen_string_literal: true

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
                dec_a      = fake(Circuit)
                dec_b      = fake(Circuit)
                decs       = [dec_a, dec_b].to_enum
                decomposer = fake(Decomposer, as: :class, call: decs)
                presenter  = fake(CircuitPresenter, as: :class)
                stub(presenter).call(dec_a, name: 'foo_0') { 'foo_0 VHDL' }
                stub(presenter).call(dec_b, name: 'foo_1') { 'foo_1 VHDL' }
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
