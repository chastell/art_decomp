require_relative '../circuit'
require_relative '../function'
require_relative '../function_merger'
require_relative '../function_simplifier'
require_relative '../pin'
require_relative '../puts'
require_relative '../wire'

module ArtDecomp
  module FunctionDecomposer
    class Parallel
      def self.decompose(function, merger: FunctionMerger,
                                   simplifier: FunctionSimplifier)
        new(function, merger: merger, simplifier: simplifier).decompositions
      end

      def initialize(function, merger:, simplifier:)
        @function   = function
        @merger     = merger
        @simplifier = simplifier
      end

      def decompositions
        Enumerator.new do |yielder|
          is     = function.is
          split  = function.os.map { |o| Function.new Puts.new is: is, os: [o] }
          simple = split.map { |fun| simplifier.simplify fun }
          merged = merger.merge simple
          circuit = Circuit.new functions: merged, puts: function.puts
          merged.each { |fun| circuit.wires.concat wires_for(fun, circuit) }
          yielder << circuit unless merged == [function]
        end
      end

      attr_reader :function, :merger, :simplifier
      private     :function, :merger, :simplifier

      private

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
