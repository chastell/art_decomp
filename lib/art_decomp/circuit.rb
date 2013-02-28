module ArtDecomp class Circuit
  attr_accessor :wirings
  attr_reader :functions, :recoders

  def self.from_fsm opts
    ss = { i: opts.fetch(:is), o: opts.fetch(:os), q: [opts.fetch(:q)], p: [opts.fetch(:p)] }
    function_factory = opts.fetch(:function_factory) { Function }
    function = function_factory.new ss[:i] + ss[:q], ss[:o] + ss[:p]

    new(functions: [function], ss: ss).tap do |circuit|
      circuit.wirings = Hash[
        ss[:i].map.with_index { |s, n| [Pin.new(function, :i, n), Pin.new(circuit, :i, n)] } +
        [[Pin.new(function, :i, ss[:i].size), Pin.new(circuit, :q, 0)]] +
        ss[:o].map.with_index { |s, n| [Pin.new(circuit, :o, n), Pin.new(function, :o, n)] } +
        [[Pin.new(circuit, :p, 0), Pin.new(function, :o, ss[:o].size)]]
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
