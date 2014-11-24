require 'forwardable'
require_relative '../circuit'
require_relative '../function'
require_relative '../function_merger'
require_relative '../function_simplifier'
require_relative '../pin'
require_relative '../puts'
require_relative '../wire'

module ArtDecomp
  module FunctionDecomposer
    class Parallel < SimpleDelegator
      def self.decompose(function)
        new(function).decompositions
      end

      def decompositions
        Enumerator.new do |yielder|
          unless merged == [function]
            circuit = Circuit.new(functions: merged, puts: puts)
            merged.each { |fun| circuit.wires.concat wires_for(fun, circuit) }
            yielder << circuit
          end
        end
      end

      private

      alias_method :function, :__getobj__

      def merged
        @merged ||= begin
          split  = os.map { |o| Function.new(Puts.new(is: is, os: [o])) }
          simple = split.map { |fun| FunctionSimplifier.simplify(fun) }
          FunctionMerger.merge(simple)
        end
      end

      def wires_for(function, circuit)
        is_wires = function.is.map.with_index do |put, fi|
          Wire[Pin[circuit, :is, circuit.is.index(put)], Pin[function, :is, fi]]
        end
        os_wires = function.os.map.with_index do |put, fo|
          Wire[Pin[function, :os, fo], Pin[circuit, :os, circuit.os.index(put)]]
        end
        is_wires + os_wires
      end
    end
  end
end
