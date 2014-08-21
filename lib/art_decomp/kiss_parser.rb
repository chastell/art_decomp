require_relative 'circuit'
require_relative 'put'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    def self.circuit_for(kiss, circuit_factory: Circuit)
      new(kiss).circuit circuit_factory: circuit_factory
    end

    def initialize(kiss)
      cols        = kiss.lines.grep(/^[^.]/).map(&:split).transpose
      @col_groups = %i(is qs ps os).zip(cols).to_h
    end

    def circuit(circuit_factory:)
      circuit_factory.from_fsm Puts.new is: is, os: os, qs: qs, ps: ps
    end

    attr_reader :col_groups
    private     :col_groups

    private

    def is
      put_cols_from_group :is
    end

    def os
      put_cols_from_group :os
    end

    def ps
      column = col_groups[:ps].map(&:to_sym)
      [Put.from_column(column, dont_care: :*, codes: states)]
    end

    def put_cols_from_group(name)
      rows = col_groups[name].map { |string| string.split('').map(&:to_sym) }
      rows.transpose.map { |column| Put.from_column column }
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
