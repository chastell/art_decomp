module ArtDecomp class KISSParser
  def self.circuit_from_kiss kiss
    new(kiss).circuit
  end

  def initialize kiss
    @kiss = kiss
  end

  def circuit(circuit_factory: Circuit)
    circuit_factory.from_fsm is: is, os: os, q: q, p: p
  end

  attr_reader :kiss
  private     :kiss

  private

  def col_groups
    cols = kiss.lines.grep(/^[^.]/).map(&:split).transpose
    Hash[[:is, :q, :p, :os].zip cols]
  end

  def hashify col, keys, dc
    Hash[keys.map do |key|
      [key.to_sym, col.each_index.select { |i| col[i] == key or col[i] == dc }]
    end]
  end

  def is
    pluck_columns(col_groups[:is]).map { |col| hashify col, ['0', '1'], '-' }
  end

  def os
    pluck_columns(col_groups[:os]).map { |col| hashify col, ['0', '1'], '-' }
  end

  def p
    hashify col_groups[:p], states, '*'
  end

  def pluck_columns col_group
    col_group.map { |str| str.split '' }.transpose
  end

  def q
    hashify col_groups[:q], states, '*'
  end

  def states
    (col_groups[:q] + col_groups[:p]).uniq - ['*']
  end
end end
