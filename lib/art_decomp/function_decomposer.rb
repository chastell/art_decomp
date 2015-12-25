require_relative 'function_decomposer/parallel'
require_relative 'function_decomposer/serial'

module ArtDecomp
  module FunctionDecomposer
    module_function

    # :reek:DuplicateMethodCall { max_calls: 2 }
    def decompose(function, parallel: Parallel, serial: Serial)
      Enumerator.new do |yielder|
        parallel.decompose(function).each { |circuit| yielder << circuit }
        serial.decompose(function).each   { |circuit| yielder << circuit }
      end
    end
  end
end
