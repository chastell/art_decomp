module ArtDecomp class Circuit
  attr_accessor :functions, :recoders, :wires
  attr_reader   :is, :os, :ps, :qs

  def self.from_fsm is: [], os: [], ps: [], qs: []
    fun = Function.new is + qs, os + ps

    new(functions: [fun], is: is, os: os, ps: ps, qs: qs).tap do |circ|
      circ.wires =
        (0...is.size).map { |n| Wire.new(circ.is[n], fun.is[n]) } +
        [Wire.new(circ.qs[0], fun.is[is.size])] +
        (0...os.size).map { |n| Wire.new(fun.os[n], circ.os[n]) } +
        [Wire.new(fun.os[os.size], circ.ps[0])]
    end
  end

  def initialize functions: [], is: [], os: [], ps: [], qs: [], recoders: [], wires: []
    @functions, @recoders, @wires = functions, recoders, wires
    @is, @os, @ps, @qs = is, os, ps, qs
  end

  def binwidths group
    send(group).map(&:binwidth)
  end

  def largest_function
  end

  def max_size circuit_sizer: CircuitSizer.new
    @max_size ||= circuit_sizer.max_size functions.map(&:arch)
  end

  def min_size circuit_sizer: CircuitSizer.new
    @min_size ||= circuit_sizer.min_size functions.map(&:arch)
  end
end end
