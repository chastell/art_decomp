module ArtDecomp class KISSParser
  def self.circuit_for kiss, kiss_parser_factory: self
    kiss_parser_factory.new(kiss).circuit
  end

  def initialize kiss
    @kiss = kiss
  end

  def circuit circuit_factory: Circuit
    circuit_factory.from_fsm is: is, os: os, qs: qs, ps: ps
  end

  attr_reader :kiss
  private     :kiss

  private

  def col_groups
    cols = kiss.lines.grep(/^[^.]/).map(&:split).transpose
    Hash[[:is, :qs, :ps, :os].zip cols]
  end

  def is
    pluck_columns(col_groups[:is]).map { |col| putify col }
  end

  def os
    pluck_columns(col_groups[:os]).map { |col| putify col }
  end

  def pluck_columns col_group
    col_group.map { |str| str.split '' }.transpose
  end

  def ps
    [putify(col_groups[:ps], dc: '*', codes: states)]
  end

  def putify col, dc: '-', codes: ['0', '1']
    Put[Hash[codes.map do |code|
      [
        code.to_sym,
        B[*col.each_index.select { |i| col[i] == code or col[i] == dc }],
      ]
    end]]
  end

  def qs
    [putify(col_groups[:qs], dc: '*', codes: states)]
  end

  def states
    (col_groups[:qs] + col_groups[:ps]).uniq - ['*']
  end
end end
