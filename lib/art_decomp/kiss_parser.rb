require_relative 'circuit'
require_relative 'put'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    def self.circuit_for(kiss, circuit_factory: Circuit)
      new(kiss, circuit_factory: circuit_factory).circuit
    end

    def initialize(kiss, circuit_factory:)
      cols             = kiss.lines.grep(/^[^.]/).map(&:split).transpose
      @col_groups      = %i(is qs ps os).zip(cols).to_h
      @circuit_factory = circuit_factory
    end

    def circuit
      circuit_factory.from_fsm Puts.new is: is, os: os, qs: qs, ps: ps
    end

    attr_reader :circuit_factory, :col_groups
    private     :circuit_factory, :col_groups

    private

    def is
      pluck_columns(col_groups[:is]).map { |column| Put.from_column column }
    end

    def os
      pluck_columns(col_groups[:os]).map { |column| Put.from_column column }
    end

    def pluck_columns(col_group)
      col_group.map { |string| string.split('').map(&:to_sym) }.transpose
    end

    def ps
      column = col_groups[:ps].map(&:to_sym)
      [Put.from_column(column, dont_care: :*, codes: states)]
    end

    def qs
      column = col_groups[:qs].map(&:to_sym)
      [Put.from_column(column, dont_care: :*, codes: states)]
    end

    def states
      symbols = col_groups[:qs].map(&:to_sym) + col_groups[:ps].map(&:to_sym)
      symbols.uniq - [:*]
    end
  end
end
