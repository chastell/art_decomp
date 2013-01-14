module ArtDecomp class Circuit
  attr_reader :functions, :encodings

  def self.from_fsm opts = {}
    inputs  = opts.fetch :inputs
    i_state = opts.fetch :i_state
    outputs = opts.fetch :outputs
    o_state = opts.fetch :o_state

    encoding = [
      inputs.map(&:keys)  + [i_state.keys],
      outputs.map(&:keys) + [o_state.keys],
    ]
    table = [
      inputs.map(&:values)  + [i_state.values],
      outputs.map(&:values) + [o_state.values],
    ]

    function_factory = opts.fetch(:function_factory) { Function }
    function = function_factory.new encoding: encoding, table: table

    new functions: [function]
  end

  def initialize opts = {}
    @functions = opts.fetch(:functions) { [] }
  end
end end
