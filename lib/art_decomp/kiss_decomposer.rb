require 'optparse'

module ArtDecomp class KISSDecomposer
  Settings = Struct.new(*%i[kiss_path vhdl_path])

  def initialize args
    @args = args
  end

  def decompose(circuit_presenter: CircuitPresenter,
                decomposer: Decomposer.new, kiss_parser: KISSParser)
    circuit = kiss_parser.circuit_for File.read settings.kiss_path
    decomposer.decompose_circuit(circuit).each.with_index do |dc, i|
      name = "#{File.basename settings.kiss_path, '.kiss'}_#{i}"
      vhdl = circuit_presenter.vhdl_for dc, name
      File.write "#{settings.vhdl_path}/#{name}.vhdl", vhdl
    end
  end

  attr_reader :args
  private     :args

  private

  def settings
    @settings ||= Settings.new.tap do |settings|
      OptionParser.new do |opts|
        opts.on('--dir DIR', String) { |dir| settings.vhdl_path = dir }
      end.parse! args
      settings.kiss_path = args.first
    end
  end
end end
