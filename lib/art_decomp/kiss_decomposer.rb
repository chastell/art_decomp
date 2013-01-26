require 'optparse'
require 'ostruct'

module ArtDecomp class KISSDecomposer
  def initialize opts = {}
    @decomposer     = opts.fetch(:decomposer)     { Decomposer.new    }
    @kiss_parser    = opts.fetch(:kiss_parser)    { KISSParser.new    }
    @vhdl_presenter = opts.fetch(:vhdl_presenter) { VHDLPresenter.new }
  end

  def decompose args
    options    = options_from args
    circuit    = kiss_parser.circuit_for File.read options.kiss_path
    decomposed = decomposer.decompose circuit
    vhdl       = vhdl_presenter.vhdl_for decomposed
    name       = File.basename options.kiss_path, '.kiss'
    File.write "#{options.vhdl_path}/#{name}.vhdl", vhdl
  end

  attr_reader :decomposer, :kiss_parser, :vhdl_presenter
  private     :decomposer, :kiss_parser, :vhdl_presenter

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
