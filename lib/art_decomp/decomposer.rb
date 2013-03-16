module ArtDecomp class Decomposer
  def self.decompose_circuit circuit, width: nil
    new(circuit, width: width).decompose
  end
end end
