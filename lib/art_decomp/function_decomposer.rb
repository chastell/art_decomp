require_relative 'function_decomposer/parallel'
require_relative 'function_decomposer/serial'

module ArtDecomp
  module FunctionDecomposer
    def self.decompose(function, parallel: Parallel, serial: Serial.new)
      Enumerator.new do |yielder|
        parallel.decompose(function).each { |circuit| yielder << circuit }
        serial.decompose(function).each   { |circuit| yielder << circuit }
      end
    end
  end
end
