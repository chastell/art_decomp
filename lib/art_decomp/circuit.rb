module ArtDecomp class Circuit
  attr_accessor :functions, :recoders, :wirings

  def self.from_fsm(function_factory: Function, is: nil, os: nil, q: nil, p: nil)
    fun = function_factory.new is + [q], os + [p]
    ss  = { i: is, o: os, q: [q], p: [p] }

    new(functions: [fun], ss: ss).tap do |circ|
      circ.wirings = Hash[
        (0...is.size).map { |n| [Pin.new(fun, :i, n), Pin.new(circ, :i, n)] } +
        [[Pin.new(fun, :i, is.size), Pin.new(circ, :q, 0)]] +
        (0...os.size).map { |n| [Pin.new(circ, :o, n), Pin.new(fun, :o, n)] } +
        [[Pin.new(circ, :p, 0), Pin.new(fun, :o, os.size)]]
      ]
    end
  end

  def initialize(functions: [], recoders: [], ss: {}, wirings: {})
    @functions, @recoders, @ss, @wirings = functions, recoders, ss, wirings
  end

  def widths group
    ss[group].map { |s| Math.log2(s.size).ceil }
  end

  attr_reader :ss
  private     :ss
end end
