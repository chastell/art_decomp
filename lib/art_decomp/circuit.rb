module ArtDecomp class Circuit
  attr_reader :functions

  def self.from_fsm opts
    is = opts.fetch :is
    os = opts.fetch :os
    q  = opts.fetch :q
    p  = opts.fetch :p

    function_factory = opts.fetch(:function_factory) { Function }
    function = function_factory.new is + [q], os + [p]

    new functions: [function]
  end

  def initialize opts = {}
    @functions = opts.fetch(:functions) { [] }
  end
end end
