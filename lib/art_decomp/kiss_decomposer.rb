module ArtDecomp class KISSDecomposer
  def initialize opts = {}
    @decomposer     = opts.fetch(:decomposer)     { Decomposer.new    }
    @kiss_parser    = opts.fetch(:kiss_parser)    { KISSParser.new    }
    @vhdl_presenter = opts.fetch(:vhdl_presenter) { VHDLPresenter.new }
  end

  def decompose args
    _, vhdl_path, kiss_path = args
    circuit    = kiss_parser.circuit_for File.read kiss_path
    decomposed = decomposer.decompose circuit
    vhdl       = vhdl_presenter.vhdl_for decomposed
    name       = File.basename kiss_path, '.kiss'
    File.write "#{vhdl_path}/#{name}.vhdl", vhdl
  end

  attr_reader :decomposer, :kiss_parser, :vhdl_presenter
  private     :decomposer, :kiss_parser, :vhdl_presenter
end end
