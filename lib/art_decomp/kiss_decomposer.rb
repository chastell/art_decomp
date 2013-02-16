require 'optparse'
require 'ostruct'

module ArtDecomp class KISSDecomposer
  def initialize opts = {}
    @decomposer                = opts.fetch(:decomposer)                { Decomposer.new   }
    @kiss_parser_factory       = opts.fetch(:kiss_parser_factory)       { KISSParser       }
    @circuit_presenter_factory = opts.fetch(:circuit_presenter_factory) { CircuitPresenter }
  end

  def decompose args
    options    = options_from args
    circuit    = kiss_parser_factory.new(File.read options.kiss_path).circuit
    decomposed = decomposer.decompose circuit
    vhdl       = circuit_presenter_factory.new(decomposed).vhdl
    name       = File.basename options.kiss_path, '.kiss'
    File.write "#{options.vhdl_path}/#{name}.vhdl", vhdl
  end

  attr_reader :circuit_presenter_factory, :decomposer, :kiss_parser_factory
  private     :circuit_presenter_factory, :decomposer, :kiss_parser_factory

  private

  def options_from args
    OpenStruct.new.tap do |options|
      OptionParser.new do |opts|
        opts.on('--dir DIR', String) { |dir| options.vhdl_path = dir }
      end.parse! args
      options.kiss_path = args.first
    end
  end
end end
