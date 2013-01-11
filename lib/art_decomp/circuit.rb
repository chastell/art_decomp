module ArtDecomp class Circuit
  attr_reader :functions

  def self.from_fsm opts = {}
    inputs  = opts.fetch :inputs
    i_state = opts.fetch :i_state
    outputs = opts.fetch :outputs
    o_state = opts.fetch :o_state
    function_factory = opts.fetch(:function_factory) { Function }
    function = function_factory.new inputs.map(&:values) + [i_state.values], outputs.map(&:values) + [o_state.values]
    new functions: [function]
  end

  def initialize opts = {}
    @functions = opts.fetch(:functions) { [] }
  end
end end
