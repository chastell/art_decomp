require 'optparse'
require 'ostruct'

module ArtDecomp class KISSDecomposer
  def initialize opts = {}
    @decomposer = opts.fetch(:decomposer) { Decomposer.new }
  end

  def decompose args, opts = {}
    options = options_from args
    kiss    = File.read options.kiss_path
    circuit = opts.fetch(:kiss_parser) { KISSParser.new kiss }.circuit
    decd    = decomposer.decompose circuit

    vhdl = opts.fetch(:circuit_presenter) { CircuitPresenter.new decd }.vhdl
    name = File.basename options.kiss_path, '.kiss'

    File.write "#{options.vhdl_path}/#{name}.vhdl", vhdl
  end

  attr_reader :decomposer
  private     :decomposer

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
