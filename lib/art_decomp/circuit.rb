module ArtDecomp class Circuit
  def self.from_fsm opts = {}
    inputs  = opts.fetch :inputs
    i_state = opts.fetch :i_state
    outputs = opts.fetch :outputs
    o_state = opts.fetch :o_state
    function_factory = opts.fetch(:function_factory) { Function }
    function_factory.new inputs.map(&:values) + [i_state.values], outputs.map(&:values) + [o_state.values]
  end
end end
