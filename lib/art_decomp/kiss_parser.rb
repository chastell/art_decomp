require_relative 'circuit'
require_relative 'put'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    def self.circuit_for(kiss)
      new(kiss).circuit
    end

    def initialize(kiss)
      cols        = kiss.lines.grep(/^[^.]/).map(&:split).transpose
      @col_groups = %i(is qs ps os).zip(cols).to_h
    end

    def circuit
      Circuit.from_fsm(is: is, os: os, qs: qs, ps: ps)
    end

    private_attr_reader :col_groups

    private

    def is
      put_cols_from_group(:is)
    end

    def os
      put_cols_from_group(:os)
    end

    def ps
      state_cols_from_group(:ps)
    end

    def put_cols_from_group(name)
      rows = col_groups[name].map { |string| string.split('').map(&:to_sym) }
      Puts.new(rows.transpose.map { |column| Put.from_column(column) })
    end

    def qs
      state_cols_from_group(:qs)
    end

    def state_codes
      symbols = col_groups[:qs].map(&:to_sym) + col_groups[:ps].map(&:to_sym)
      symbols.uniq - [:*]
    end

    def state_cols_from_group(name)
      column = col_groups[name].map(&:to_sym)
      Puts.new([Put.from_column(column, dont_care: :*, codes: state_codes)])
    end
  end
end
