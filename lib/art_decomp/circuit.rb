module ArtDecomp class Circuit
  attr_reader :functions, :recoders, :wirings

  def self.from_fsm opts
    is = opts.fetch :is
    os = opts.fetch :os
    q  = opts.fetch :q
    p  = opts.fetch :p

    function_factory = opts.fetch(:function_factory) { Function }
    function = function_factory.new is + [q], os + [p]

    new functions: [function], ss: { i: is, o: os, q: [q], p: [p] }
  end

  def initialize opts = {}
    @ss        = opts.fetch(:ss)        { {} }
    @functions = opts.fetch(:functions) { [] }
    @recoders  = opts.fetch(:recoders)  { [] }
    @wirings   = opts.fetch(:wirings)   { [] }
  end

  def i_widths
    (ss[:i] || []).map { |i| Math.log2(i.size).ceil }
  end

  def o_widths
    (ss[:o] || []).map { |o| Math.log2(o.size).ceil }
  end

  def p_widths
    (ss[:p] || []).map { |p| Math.log2(p.size).ceil }
  end

  def q_widths
    (ss[:q] || []).map { |q| Math.log2(q.size).ceil }
  end

  attr_reader :ss
  private     :ss
end end
