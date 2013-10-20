module ArtDecomp class FunctionDecomposer; class Parallel
  def initialize(function_merger: FunctionMerger.new,
                 function_simplifier: FunctionSimplifier.new)
    @function_merger     = function_merger
    @function_simplifier = function_simplifier
  end

  def decompose function
    Enumerator.new do |yielder|
      merged  = merge function
      circuit = Circuit.new functions: merged,
        puts: Puts.new(is: function.is, os: function.os)
      merged.each { |fun| add_wires fun, circuit }
      yielder << circuit unless merged == [function]
    end
  end

  attr_reader :function_merger, :function_simplifier
  private     :function_merger, :function_simplifier

  private

  def add_is_wires fun, circuit
    fun.is.each.with_index do |put, fi|
      ci = circuit.puts.is.index put
      circuit.wires << Wire[Pin[circuit, :is, ci], Pin[fun, :is, fi]]
    end
  end

  def add_os_wires fun, circuit
    fun.os.each.with_index do |put, fo|
      co = circuit.puts.os.index put
      circuit.wires << Wire[Pin[fun, :os, fo], Pin[circuit, :os, co]]
    end
  end

  def add_wires fun, circuit
    add_is_wires fun, circuit
    add_os_wires fun, circuit
  end

  def merge function
    split  = function.os.map { |o| Function.new function.is, [o] }
    simple = split.map { |fun| function_simplifier.simplify fun }
    function_merger.merge simple
  end
end end end
