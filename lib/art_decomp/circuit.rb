module ArtDecomp class Circuit
  attr_reader :functions, :recoders, :wirings

  def self.from_fsm opts
    ss = { i: opts.fetch(:is), o: opts.fetch(:os), q: [opts.fetch(:q)], p: [opts.fetch(:p)] }
    function_factory = opts.fetch(:function_factory) { Function }
    functions = [function_factory.new(ss[:i] + ss[:q], ss[:o] + ss[:p])]

    new functions: functions, ss: ss
  end

  def initialize opts = {}
    @ss        = opts.fetch(:ss)        { {} }
    @functions = opts.fetch(:functions) { [] }
    @recoders  = opts.fetch(:recoders)  { [] }
    @wirings   = opts.fetch(:wirings)   { {} }
  end

  def widths group
    ss[group].map { |s| Math.log2(s.size).ceil }
  end

  attr_reader :ss
  private     :ss
end end
