# frozen_string_literal: true

require_relative 'circuit_solder'
require_relative 'function_decomposer'

module ArtDecomp
  module CircuitDecomposer
    module_function

    def call(circuit, circuit_solder: CircuitSolder,
             function_decomposer: FunctionDecomposer)
      function = circuit.largest_function
      Enumerator.new do |yielder|
        function_decomposer.call(function).each do |decomposed|
          replaced = circuit_solder.call(composed:   circuit,
                                         decomposed: decomposed,
                                         function:   function)
          yielder << replaced
        end
      end
    end
  end
end
