module ArtDecomp class KISSParser
  def self.circuit_for kiss, kiss_parser: new(kiss)
    kiss_parser.circuit
  end

  def initialize kiss
    @kiss = kiss
  end

  def circuit circuit_factory: Circuit
    circuit_factory.from_fsm Puts.new is: is, os: os, qs: qs, ps: ps
  end

  attr_reader :kiss
  private     :kiss

  private

  def col_groups
    cols = kiss.lines.grep(/^[^.]/).map(&:split).transpose
    %i(is qs ps os).zip(cols).to_h
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

  def putify col, dc: '-', codes: %w(0 1)
    Put[codes.map do |code|
      [
        code.to_sym,
        B[*col.each_index.select { |i| col[i] == code or col[i] == dc }],
      ]
    end.to_h]
  end

  def qs
    [putify(col_groups[:qs], dc: '*', codes: states)]
  end

  def states
    (col_groups[:qs] + col_groups[:ps]).uniq - ['*']
  end
end end
