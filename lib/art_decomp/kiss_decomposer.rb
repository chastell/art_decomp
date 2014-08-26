require_relative 'circuit_presenter'
require_relative 'decomposer'
require_relative 'kiss_parser'
require_relative 'settings'

module ArtDecomp
  class KISSDecomposer
    def initialize(args)
      @settings = Settings.new args
    end

    def decompose(circuit_presenter: CircuitPresenter,
                  decomposer: Decomposer, kiss_parser: KISSParser)
      circuit = kiss_parser.circuit_for File.read settings.kiss_path
      decomposer.decompose_circuit(circuit).each.with_index do |dc, i|
        name = "#{File.basename settings.kiss_path, '.kiss'}_#{i}"
        vhdl = circuit_presenter.vhdl_for dc, name
        File.write "#{settings.vhdl_path}/#{name}.vhdl", vhdl
      end
    end

    attr_reader :settings
    private     :settings
  end
end
