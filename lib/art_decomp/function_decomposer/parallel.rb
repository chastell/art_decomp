require 'delegate'
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

      def decompositions                       # rubocop:disable Metrics/AbcSize
        Enumerator.new do |yielder|
          unless merged == [function]
            wires = merged.map { |f| Wirer.new(f, ins, outs).wires }.reduce(:+)
            yielder << Circuit.new(functions: merged, ins: ins, outs: outs,
                                   wires: wires)
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

        def ins_wires                          # rubocop:disable Metrics/AbcSize
          Wires.from_array(function.ins.map.with_index do |put, fi|
            c_offset = ins[0...ins.index(put)].map(&:binwidth).reduce(0, :+)
            f_offset = function.ins[0...fi].map(&:binwidth).reduce(0, :+)
            [[:circuit, :ins, ins.index(put), put.binwidth, c_offset],
             [function, :ins, fi,             put.binwidth, f_offset]]
          end)
        end

        def outs_wires                         # rubocop:disable Metrics/AbcSize
          Wires.from_array(function.outs.map.with_index do |put, fo|
            c_offset = outs[0...outs.index(put)].map(&:binwidth).reduce(0, :+)
            f_offset = function.outs[0...fo].map(&:binwidth).reduce(0, :+)
            [[function, :outs, fo,              put.binwidth, f_offset],
             [:circuit, :outs, outs.index(put), put.binwidth, c_offset]]
          end)
        end
      end
    end
  end
end
