require_relative 'circuit_solder'
require_relative 'function_decomposer'

module ArtDecomp
  module CircuitDecomposer
    def self.decompose(circuit, circuit_solder: CircuitSolder.new,
                                function_decomposer: FunctionDecomposer)
      function = circuit.largest_function
      Enumerator.new do |yielder|
        function_decomposer.decompose(function).each do |decomposed|
          yielder << circuit_solder.replace(circuit, function, decomposed)
        end
      end
    end
  end
end
