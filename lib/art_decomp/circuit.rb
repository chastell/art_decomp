module ArtDecomp class Circuit
  attr_reader :functions, :encodings

  def self.from_fsm opts = {}
    inputs  = opts.fetch :inputs
    i_state = opts.fetch :i_state
    outputs = opts.fetch :outputs
    o_state = opts.fetch :o_state
    function_factory = opts.fetch(:function_factory) { Function }
    function = function_factory.new inputs.map(&:values) + [i_state.values], outputs.map(&:values) + [o_state.values]
    new functions: [function], encodings: {
      function => [inputs.map(&:keys) + [i_state.keys], outputs.map(&:keys) + [o_state.keys]]
    }
  end

  def initialize opts = {}
    @encodings = opts.fetch(:encodings) { {} }
    @functions = opts.fetch(:functions) { [] }
  end
end end
