module ArtDecomp class Circuit
  attr_accessor :functions, :recoders, :wires
  attr_reader   :is, :os, :ps, :qs

  def self.from_fsm is: [], os: [], ps: [], qs: []
    fun = Function.new is + qs, os + ps

    new(functions: [fun], is: is, os: os, ps: ps, qs: qs).tap do |circ|
      circ.wires =
        (0...is.size).map { |n| Wire[Pin[circ, :is, n], Pin[fun, :is, n]] } +
        [Wire[Pin[circ, :qs, 0], Pin[fun, :is, is.size]]] +
        (0...os.size).map { |n| Wire[Pin[fun, :os, n], Pin[circ, :os, n]] } +
        [Wire[Pin[fun, :os, os.size], Pin[circ, :ps, 0]]]
    end
  end

  def initialize functions: [], is: [], os: [], ps: [], qs: [], recoders: [],
                 wires: []
    @functions, @recoders, @wires = functions, recoders, wires
    @is, @os, @ps, @qs = is, os, ps, qs
  end

  def == other
    functions == other.functions and is == other.is and os == other.os and
      ps == other.ps and qs == other.qs and recoders == other.recoders and
      wires == other.wires
  end

  def adm_size circuit_sizer: CircuitSizer.new(self)
    @adm_size ||= circuit_sizer.adm_size
  end

  def binwidths group
    send(group).map(&:binwidth)
  end

  def function_archs
    functions.map(&:arch)
  end

  def largest_function
    functions.max_by(&:arch)
  end

  def max_size circuit_sizer: CircuitSizer.new(self)
    @max_size ||= circuit_sizer.max_size
  end

  def min_size circuit_sizer: CircuitSizer.new(self)
    @min_size ||= circuit_sizer.min_size
  end
end end
