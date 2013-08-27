module ArtDecomp class CircuitDecomposer
  def decompose circuit, function_decomposer: FunctionDecomposer.new,
                circuit_solder: CircuitSolder.new
    function = circuit.largest_function
    Enumerator.new do |yielder|
      function_decomposer.decompose(function).each do |decomposed|
        yielder << circuit_solder.replace(circuit, function, decomposed)
      end
    end
  end
end end
