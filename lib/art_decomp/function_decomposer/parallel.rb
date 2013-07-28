module ArtDecomp class FunctionDecomposer; class Parallel
  def decompose function, function_merger: FunctionMerger.new, function_simplifier: FunctionSimplifier.new
    Enumerator.new do |yielder|
      split  = function.os.map { |o| Function.new function.is, [o] }
      simple = split.map { |fun| function_simplifier.simplify fun }
      merged = function_merger.merge simple

      circuit = Circuit.new functions: merged, is: function.is, os: function.os

      merged.each do |fun|
        fun.is.each.with_index do |put, fi|
          ci = circuit.is.index put
          circuit.wires << Wire.new(Pin[circuit, :is, ci], Pin[fun, :is, fi])
        end
        fun.os.each.with_index do |put, fo|
          co = circuit.os.index put
          circuit.wires << Wire.new(Pin[fun, :os, fo], Pin[circuit, :os, co])
        end
      end

      yielder << circuit unless merged == [function]
    end
  end
end end end
