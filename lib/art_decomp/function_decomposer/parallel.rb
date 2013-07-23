module ArtDecomp class FunctionDecomposer; class Parallel
  def decompose function, function_merger: FunctionMerger.new, function_simplifier: FunctionSimplifier.new
    Enumerator.new do |yielder|
      split  = function.os.map { |o| Function.new function.is, [o] }
      simple = split.map { |fun| function_simplifier.simplify fun }
      merged = function_merger.merge simple

      circuit = Circuit.new functions: merged, is: function.is, os: function.os

      merged.each do |fun|
        fun.is.each do |fi|
          circuit.wires << Wire.new(circuit.is.find { |ci| ci == fi }, fi)
        end
        fun.os.each do |fo|
          circuit.wires << Wire.new(fo, circuit.os.find { |co| co == fo })
        end
      end

      yielder << circuit
    end
  end
end end end
