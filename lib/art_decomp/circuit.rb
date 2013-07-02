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

  def initialize functions: [], is: [], os: [], ps: [], qs: [], recoders: [],
                 wires: []
    @functions, @recoders, @wires = functions, recoders, wires
    @is, @os, @ps, @qs = is, os, ps, qs
  end

  def binwidths group
    send(group).map(&:binwidth)
  end

  def not_smaller_than circuit_sizer: CircuitSizer
    @not_smaller_than ||= circuit_sizer.not_smaller_than functions.map(&:arch)
  end

  def size circuit_sizer: CircuitSizer
    @size ||= circuit_sizer.size functions.map(&:arch)
  end
end end
