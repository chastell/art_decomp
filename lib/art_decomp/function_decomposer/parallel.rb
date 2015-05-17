require 'delegate'
require_relative '../fsm'
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

      def decompositions                       # rubocop:disable Metrics/AbcSize
        Enumerator.new do |yielder|
          unless merged == [function]
            wires = merged.map { |f| Wirer.new(f, ins, outs).wires }.reduce(:+)
            yielder << FSM.new(functions: merged, ins: ins, outs: outs,
                               states: Puts.new, next_states: Puts.new,
                               recoders: [], wires: wires)
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

      class Wirer
        def initialize(function, ins, outs)
          @function, @ins, @outs = function, ins, outs
        end

        def wires
          ins_wires + outs_wires
        end

        private

        private_attr_reader :function, :ins, :outs

        def ins_wires
          Wires.from_array(function.ins.map.with_index do |put, fi|
            [[:circuit, :ins, ins.index(put)], [function, :ins, fi]]
          end)
        end

        def outs_wires
          Wires.from_array(function.outs.map.with_index do |put, fo|
            [[function, :outs, fo], [:circuit, :outs, outs.index(put)]]
          end)
        end
      end
    end
  end
end
