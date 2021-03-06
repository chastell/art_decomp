require 'delegate'
require 'procto'
require_relative '../circuit'
require_relative '../function'
require_relative '../function_merger'
require_relative '../function_simplifier'
require_relative '../puts'
require_relative '../wires'

module ArtDecomp
  module FunctionDecomposer
    class Parallel < DelegateClass(Function)
      include Procto.call

      def call
        Enumerator.new do |yielder|
          unless merged == [function]
            wires = Wires.from_function(function)
            circ  = Circuit.new(functions: merged, own: function, wires: wires)
            yielder << circ
          end
        end
      end

      private

      alias function __getobj__

      def merged
        @merged ||= begin
          split = outs.map { |out| Function[ins, Puts.new([out])] }
          simple = split.map { |fun| FunctionSimplifier.call(fun) }
          FunctionMerger.merge(simple)
        end
      end
    end
  end
end
