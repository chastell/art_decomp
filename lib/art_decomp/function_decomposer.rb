# frozen_string_literal: true

require_relative 'function_decomposer/parallel'
require_relative 'function_decomposer/serial'

module ArtDecomp
  module FunctionDecomposer
    module_function

    def call(function, parallel: Parallel, serial: Serial)
      Enumerator.new do |yielder|
        parallel.call(function).each { |circuit| yielder << circuit }
        serial.call(function).each   { |circuit| yielder << circuit }
      end
    end
  end
end
