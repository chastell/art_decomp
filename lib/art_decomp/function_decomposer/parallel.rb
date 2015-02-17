require 'forwardable'
require_relative '../circuit'
require_relative '../function'
require_relative '../function_merger'
require_relative '../function_simplifier'
require_relative '../puts'
require_relative '../wires'

module ArtDecomp
  module FunctionDecomposer
    class Parallel < SimpleDelegator
      def self.decompose(function)
        new(function).decompositions
      end

      def decompositions
        Enumerator.new do |yielder|
          unless merged == [function]
            wires = merged.map { |f| Wirer.new(f, is, os).wires }.reduce(:+)
            circ  = Circuit.new(functions: merged, is: is, os: os, wires: wires)
            yielder << circ
          end
        end
      end

      private

      alias_method :function, :__getobj__

      def merged
        @merged ||= begin
          split = os.map do |o|
            Function.new(is: is, os: Puts.new([o]))
          end
          simple = split.map { |fun| FunctionSimplifier.simplify(fun) }
          FunctionMerger.merge(simple)
        end
      end

      class Wirer
        def initialize(function, is, os)
          @function, @is, @os = function, is, os
        end

        def wires
          is_wires + os_wires
        end

        private_attr_reader :function, :is, :os

        private

        def is_wires
          Wires.from_array(function.is.map.with_index do |put, fi|
            [[:circuit, :is, is.index(put)], [function, :is, fi]]
          end)
        end

        def os_wires
          Wires.from_array(function.os.map.with_index do |put, fo|
            [[function, :os, fo], [:circuit, :os, os.index(put)]]
          end)
        end
      end
    end
  end
end
