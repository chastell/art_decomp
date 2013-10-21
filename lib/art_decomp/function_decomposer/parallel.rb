module ArtDecomp class FunctionDecomposer; class Parallel
  def initialize(function_merger: FunctionMerger.new,
                 function_simplifier: FunctionSimplifier.new)
    @function_merger     = function_merger
    @function_simplifier = function_simplifier
  end

  def decompose function
    Enumerator.new do |yielder|
      merged  = merge function
      circuit = Circuit.new functions: merged, puts: function.puts
      merged.each { |fun| add_wires fun, circuit }
      yielder << circuit unless merged == [function]
    end
  end

  attr_reader :function_merger, :function_simplifier
  private     :function_merger, :function_simplifier

  private

  def add_is_wires fun, circuit
    fun.puts.is.each.with_index do |put, fi|
      ci = circuit.puts.is.index put
      circuit.wires << Wire[Pin[circuit, :is, ci], Pin[fun, :is, fi]]
    end
  end

  def add_os_wires fun, circuit
    fun.puts.os.each.with_index do |put, fo|
      co = circuit.puts.os.index put
      circuit.wires << Wire[Pin[fun, :os, fo], Pin[circuit, :os, co]]
    end
  end

  def add_wires fun, circuit
    add_is_wires fun, circuit
    add_os_wires fun, circuit
  end

  def merge function
    is     = function.puts.is
    split  = function.puts.os.map { |o| Function.new Puts.new is: is, os: [o] }
    simple = split.map { |fun| function_simplifier.simplify fun }
    function_merger.merge simple
  end
end end end
