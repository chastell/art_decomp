module ArtDecomp class Circuit
  extend Forwardable

  attr_accessor :wires
  attr_reader   :functions, :puts, :recoders

  def self.from_fsm puts
    iss = puts.is.size
    oss = puts.os.size
    fun = Function.new Puts.new is: puts.is + puts.qs, os: puts.os + puts.ps
    new(functions: [fun], puts: puts).tap do |circ|
      circ.wires =
        (0...iss).map { |n| Wire[Pin[circ, :is, n], Pin[fun, :is, n]] } +
        [Wire[Pin[circ, :qs, 0], Pin[fun, :is, iss]]] +
        (0...oss).map { |n| Wire[Pin[fun, :os, n], Pin[circ, :os, n]] } +
        [Wire[Pin[fun, :os, oss], Pin[circ, :ps, 0]]]
    end
  end

  def initialize(functions: [], puts: Puts.new, recoders: [], wires: [])
    @functions, @puts, @recoders, @wires = functions, puts, recoders, wires
  end

  def == other
    functions == other.functions and puts == other.puts and
      recoders == other.recoders and wires == other.wires
  end

  def adm_size(circuit_sizer: CircuitSizer.new(self))
    @adm_size ||= circuit_sizer.adm_size
  end

  delegate %i[binwidths is os ps qs] => :puts

  def function_archs
    functions.map(&:arch)
  end

  def largest_function
    functions.max_by(&:arch)
  end

  def max_size(circuit_sizer: CircuitSizer.new(self))
    @max_size ||= circuit_sizer.max_size
  end

  def min_size(circuit_sizer: CircuitSizer.new(self))
    @min_size ||= circuit_sizer.min_size
  end
end end
