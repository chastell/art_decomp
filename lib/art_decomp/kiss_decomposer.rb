require 'optparse'
require 'ostruct'

module ArtDecomp class KISSDecomposer
  def initialize args
    @settings = settings_from args
  end

  def decompose(circuit_provider: KISSParser, decomposer: Decomposer,
                vhdl_provider: CircuitPresenter)
    kiss = File.read settings.kiss_path
    name = File.basename settings.kiss_path, '.kiss'
    circuit = circuit_provider.circuit_from_kiss kiss
    decomposer.decompositions_for(circuit).each.with_index do |decomposed, i|
      vhdl = vhdl_provider.vhdl_for_circuit decomposed, name
      File.write "#{settings.vhdl_path}/#{name}.#{i}.vhdl", vhdl
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
