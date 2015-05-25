require 'delegate'
require_relative '../circuit'
require_relative '../function'
require_relative '../function_merger'
require_relative '../function_simplifier'
require_relative '../puts'
require_relative '../wirer'

module ArtDecomp
  module FunctionDecomposer
    class Parallel < SimpleDelegator
      def self.decompose(function)
        new(function).decompositions
      end

      def decompositions                       # rubocop:disable Metrics/AbcSize
        Enumerator.new do |yielder|
          unless merged == [function]
            wires = merged.map do |fun|
              Wirer.new(fun, ins: ins, outs: outs).wires
            end.reduce(:+)
            yielder << Circuit.new(functions: merged, wires: wires)
          end
        end
      end

      private

      alias_method :function, :__getobj__

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
