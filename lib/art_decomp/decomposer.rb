module ArtDecomp class Decomposer
  def self.decompose_circuit circuit, width: nil
    new(circuit, width: width).decompose
  end

  def initialize circuit, width: nil
    @circuit, @width = circuit, width
  end

  def decompose(function_decomposer: nil)
    while circuit.max_width > width
      widest   = circuit.widest_function
      @circuit = circuit.replace widest, function_decomposer.decompose(widest, width: width)
    end
    circuit
  end

  attr_reader :circuit, :width
  private     :circuit, :width
end end
