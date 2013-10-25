module ArtDecomp class FunctionDecomposer; class Parallel
  def initialize(function_merger: FunctionMerger.new,
                 function_simplifier: FunctionSimplifier)
    @function_merger     = function_merger
    @function_simplifier = function_simplifier
  end

  def decompose function
    Enumerator.new do |yielder|
      merged  = merge function
      circuit = Circuit.new functions: merged, puts: function.puts
      merged.each { |fun| circuit.wires.concat wires_for(fun, circuit) }
      yielder << circuit unless merged == [function]
    end
  end

  attr_reader :function_merger, :function_simplifier
  private     :function_merger, :function_simplifier

  private

  def merge function
    is     = function.is
    split  = function.os.map { |o| Function.new Puts.new is: is, os: [o] }
    simple = split.map { |fun| function_simplifier.simplify fun }
    function_merger.merge simple
  end

  def wires_for function, circuit
    is_wires = function.is.map.with_index do |put, fi|
      Wire[Pin[circuit, :is, circuit.is.index(put)], Pin[function, :is, fi]]
    end
    os_wires = function.os.map.with_index do |put, fo|
      Wire[Pin[function, :os, fo], Pin[circuit, :os, circuit.os.index(put)]]
    end
    is_wires + os_wires
  end
end end end
