require 'delegate'
require_relative '../circuit'
require_relative '../function'
require_relative '../function_merger'
require_relative '../function_simplifier'
require_relative '../puts'

module ArtDecomp
  module FunctionDecomposer
    class Parallel < SimpleDelegator
      def self.decompose(function)
        new(function).decompositions
      end

      def decompositions
        Enumerator.new do |yielder|
          unless merged == [function]
            in_wires  = function.ins.map  { |put| { put => put } }
            out_wires = function.outs.map { |put| { put => put } }
            wires     = (in_wires + out_wires).reduce({}, :merge)
            circ = Circuit.new(functions: merged, own: function, wires: wires)
            yielder << circ
          end
        end
      end

      private

      alias_method :function, :__getobj__

      # :reek:UncommunicativeVariableName
      def merged
        @merged ||= begin
          split = outs.map { |o| Function.new(ins: ins, outs: Puts.new([o])) }
          simple = split.map { |fun| FunctionSimplifier.simplify(fun) }
          FunctionMerger.merge(simple)
        end
      end
    end
  end
end
