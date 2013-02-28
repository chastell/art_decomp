require 'optparse'
require 'ostruct'

module ArtDecomp class KISSDecomposer
  def initialize args, decomposer: Decomposer.new
    @decomposer = decomposer
    @settings   = settings_from args
  end

  def decompose opts = {}
    kiss = File.read settings.kiss_path
    circ = opts.fetch(:kiss_parser) { KISSParser.new kiss }.circuit
    decd = decomposer.decompose circ
    vhdl = opts.fetch(:circuit_presenter) { CircuitPresenter.new decd }.vhdl
    name = File.basename settings.kiss_path, '.kiss'
    File.write "#{settings.vhdl_path}/#{name}.vhdl", vhdl
  end

  attr_reader :decomposer, :settings
  private     :decomposer, :settings

  private

  def settings_from args
    OpenStruct.new.tap do |settings|
      OptionParser.new do |opts|
        opts.on('--dir DIR', String) { |dir| settings.vhdl_path = dir }
      end.parse! args
      settings.kiss_path = args.first
    end
  end
end end
