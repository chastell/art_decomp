module ArtDecomp class FunctionDecomposer; class Parallel
  def initialize function_merger: FunctionMerger.new,
                 function_simplifier: FunctionSimplifier.new
    @function_merger     = function_merger
    @function_simplifier = function_simplifier
  end

  def decompose function
    Enumerator.new do |yielder|
      merged  = merge function
      circuit = Circuit.new functions: merged, is: function.is, os: function.os

      merged.each do |fun|
        fun.is.each.with_index do |put, fi|
          ci = circuit.is.index put
          circuit.wires << Wire[Pin[circuit, :is, ci], Pin[fun, :is, fi]]
        end
        fun.os.each.with_index do |put, fo|
          co = circuit.os.index put
          circuit.wires << Wire[Pin[fun, :os, fo], Pin[circuit, :os, co]]
        end
      end

      yielder << circuit unless merged == [function]
    end
  end

  attr_reader :function_merger, :function_simplifier
  private     :function_merger, :function_simplifier

  private

  def merge function
    split  = function.os.map { |o| Function.new function.is, [o] }
    simple = split.map { |fun| function_simplifier.simplify fun }
    function_merger.merge simple
  end
end end end
