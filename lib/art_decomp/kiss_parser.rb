module ArtDecomp class KISSParser
  DC = :-

  def initialize kiss, opts = {}
    @circuit_factory = opts.fetch(:circuit_factory) { CircuitFactory.new }
    @kiss            = kiss
  end

  def circuit
    circuit_factory.from_fsm inputs: inputs, i_state: i_state, outputs: outputs, o_state: o_state
  end

  attr_reader :circuit_factory, :kiss
  private     :circuit_factory, :kiss

  private

  def col_groups
    cols = kiss.lines.grep(/^[^.]/).map(&:split).transpose
    Hash[[:inputs, :i_state, :o_state, :outputs].zip cols]
  end

  def hashify array
    array = array.map(&:to_sym)
    Hash[(array.uniq - [DC]).map do |key|
      [key, array.each_index.select { |i| array[i] == key or array[i] == DC }]
    end]
  end

  def inputs
    pluck_columns(col_groups[:inputs]).map { |col| hashify col }
  end

  def i_state
    hashify col_groups[:i_state]
  end

  def outputs
    pluck_columns(col_groups[:outputs]).map { |col| hashify col }
  end

  def o_state
    hashify col_groups[:o_state]
  end

  def pluck_columns col_group
    col_group.map { |str| str.split '' }.transpose
  end
end end
