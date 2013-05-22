require 'optparse'
require 'ostruct'

module ArtDecomp class KISSDecomposer
  def initialize args
    @settings = settings_from args
  end

  def decompose cp: CircuitPresenter, decs: Decompositions, parser: KISSParser
    kiss = File.read settings.kiss_path
    decs.for(parser.circuit_for kiss).each.with_index do |decomposed, i|
      name = "#{File.basename settings.kiss_path, '.kiss'}_#{i}"
      vhdl = cp.vhdl_for decomposed, name
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
