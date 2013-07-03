require 'optparse'
require 'ostruct'

module ArtDecomp class KISSDecomposer
  def initialize args
    @settings = settings_from args
  end

  def decompose circuit_presenter: CircuitPresenter, decompositions: Decompositions, kiss_parser: KISSParser
    kiss = File.read settings.kiss_path
    decompositions.for(kiss_parser.circuit_for kiss).each.with_index do |dc, i|
      name = "#{File.basename settings.kiss_path, '.kiss'}_#{i}"
      vhdl = circuit_presenter.vhdl_for dc, name
      File.write "#{settings.vhdl_path}/#{name}.vhdl", vhdl
    end
  end

  attr_reader :settings
  private     :settings

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
