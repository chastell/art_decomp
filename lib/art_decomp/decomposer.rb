module ArtDecomp class Decomposer
  def self.decompose_circuit circuit, width: nil
    new(circuit, width: width).decompose
  end

  def initialize circuit, width: nil
    @circuit, @width = circuit, width
  end

  def decompose
    return circuit if circuit.max_width <= width
  end

  attr_reader :circuit, :width
  private     :circuit, :width
end end
