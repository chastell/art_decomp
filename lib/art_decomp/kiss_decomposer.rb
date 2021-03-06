require 'forwardable'
require_relative 'circuit_presenter'
require_relative 'decomposer'
require_relative 'kiss_parser'
require_relative 'settings'

module ArtDecomp
  class KISSDecomposer
    extend Forwardable

    def initialize(args, circuit_presenter: CircuitPresenter,
                   decomposer: Decomposer, kiss_parser: KISSParser)
      @circuit_presenter = circuit_presenter
      @decomposer        = decomposer
      @kiss_parser       = kiss_parser
      @settings          = Settings.new(args)
    end

    def decompose
      circuit = kiss_parser.circuit(File.read(kiss_path))
      decomposer.call(circuit).each.with_index do |dc, index|
        name = "#{File.basename(kiss_path, '.kiss')}_#{index}"
        vhdl = circuit_presenter.call(dc, name: name)
        File.write "#{vhdl_path}/#{name}.vhdl", vhdl
      end
    end

    private

    attr_reader :circuit_presenter, :decomposer, :kiss_parser, :settings

    delegate %i[kiss_path vhdl_path] => :settings
  end
end
