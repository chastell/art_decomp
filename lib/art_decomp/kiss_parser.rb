module ArtDecomp class KISSParser
  def initialize opts = {}
    @circuit_factory = opts.fetch(:circuit_factory) { Circuit }
  end

  def circuit_for kiss
    @kiss = kiss
    circuit_factory.from_fsm inputs: inputs, i_state: i_state, outputs: outputs, o_state: o_state
  end

  attr_reader :circuit_factory, :kiss
  private     :circuit_factory, :kiss

  private

  def col_groups
    cols = kiss.lines.grep(/^[^.]/).map(&:split).transpose
    Hash[[:inputs, :i_state, :o_state, :outputs].zip cols]
  end

  def hashify col, keys, dc
    Hash[keys.map do |key|
      [key.to_sym, col.each_index.select { |i| col[i] == key or col[i] == dc }]
    end]
  end

  def inputs
    pluck_columns(col_groups[:inputs]).map { |col| hashify col, ['0', '1'], '-' }
  end

  def i_state
    hashify col_groups[:i_state], states, '*'
  end

  def outputs
    pluck_columns(col_groups[:outputs]).map { |col| hashify col, ['0', '1'], '-' }
  end

  def o_state
    hashify col_groups[:o_state], states, '*'
  end

  def pluck_columns col_group
    col_group.map { |str| str.split '' }.transpose
  end

  def states
    (col_groups[:i_state] + col_groups[:o_state]).uniq - ['*']
  end
end end
