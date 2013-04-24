module ArtDecomp class KISSParser
  def self.circuit_from_kiss kiss
    new(kiss).circuit
  end

  def initialize kiss
    @kiss = kiss
  end

  def circuit(circuit_factory: Circuit)
    circuit_factory.from_fsm is: is, os: os, qs: qs, ps: ps
  end

  attr_reader :kiss
  private     :kiss

  private

  def col_groups
    cols = kiss.lines.grep(/^[^.]/).map(&:split).transpose
    Hash[[:is, :qs, :ps, :os].zip cols]
  end

  def hashify col, dc: '-', keys: ['0', '1']
    Hash[keys.map do |key|
      [
        key.to_sym,
        B[*col.each_index.select { |i| col[i] == key or col[i] == dc }],
      ]
    end]
  end

  def is
    pluck_columns(col_groups[:is]).map { |col| hashify col }
  end

  def os
    pluck_columns(col_groups[:os]).map { |col| hashify col }
  end

  def pluck_columns col_group
    col_group.map { |str| str.split '' }.transpose
  end

  def ps
    [hashify(col_groups[:ps], dc: '*', keys: states)]
  end

  def qs
    [hashify(col_groups[:qs], dc: '*', keys: states)]
  end

  def states
    (col_groups[:qs] + col_groups[:ps]).uniq - ['*']
  end
end end
