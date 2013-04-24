module ArtDecomp class Circuit
  attr_accessor :functions, :recoders, :wirings

  def self.from_fsm(fun_fact: Function, is: {}, os: {}, qs: {}, ps: {})
    fun = fun_fact.new is + qs, os + ps
    ss  = { is: is, os: os, qs: qs, ps: ps }

    new(functions: [fun], ss: ss).tap do |circ|
      circ.wirings = Hash[
        (0...is.size).map { |n| [Pin.new(fun, :is, n), Pin.new(circ, :is, n)] } +
        [[Pin.new(fun, :is, is.size), Pin.new(circ, :qs, 0)]] +
        (0...os.size).map { |n| [Pin.new(circ, :os, n), Pin.new(fun, :os, n)] } +
        [[Pin.new(circ, :ps, 0), Pin.new(fun, :os, os.size)]]
      ]
    end
  end

  def initialize(functions: [], recoders: [], ss: {}, wirings: {})
    @functions, @recoders, @ss, @wirings = functions, recoders, ss, wirings
  end

  def max_width
    functions.map(&:width).max || 0
  end

  def widths group
    ss[group].map { |s| ArtDecomp.width_of s }
  end

  attr_reader :ss
  private     :ss
end end
