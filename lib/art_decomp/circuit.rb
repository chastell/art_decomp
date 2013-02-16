module ArtDecomp class Circuit
  attr_reader :functions, :recoders, :wirings

  def self.from_fsm opts
    is = opts.fetch :is
    os = opts.fetch :os
    q  = opts.fetch :q
    p  = opts.fetch :p

    function_factory = opts.fetch(:function_factory) { Function }
    function = function_factory.new is + [q], os + [p]

    new functions: [function], is: is, os: os, qs: [q], ps: [p]
  end

  def initialize opts = {}
    @is        = opts.fetch(:is)        { [] }
    @os        = opts.fetch(:os)        { [] }
    @qs        = opts.fetch(:qs)        { [] }
    @ps        = opts.fetch(:ps)        { [] }
    @functions = opts.fetch(:functions) { [] }
    @recoders  = opts.fetch(:recoders)  { [] }
    @wirings   = opts.fetch(:wirings)   { [] }
  end

  def i_widths
    is.map { |i| Math.log2(i.size).ceil }
  end

  def o_widths
    os.map { |o| Math.log2(o.size).ceil }
  end

  def p_widths
    ps.map { |p| Math.log2(p.size).ceil }
  end

  def q_widths
    qs.map { |q| Math.log2(q.size).ceil }
  end

  attr_reader :is, :os, :ps, :qs
  private     :is, :os, :ps, :qs
end end
