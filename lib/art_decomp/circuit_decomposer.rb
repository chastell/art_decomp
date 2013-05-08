module ArtDecomp class CircuitDecomposer
  def self.decompose circuit, decomposer: FunctionDecomposer, solder: CircuitSolder
    function = circuit.largest_function
    Enumerator.new do |yielder|
      decomposer.decompose(function).each do |decomposed|
        yielder << solder.replace(circuit, function, decomposed)
      end
    end
  end
end end
