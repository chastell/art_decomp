require_relative 'circuit'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    def self.circuit_for(kiss)
      new(kiss).circuit
    end

    def initialize(kiss)
      cols        = kiss.lines.grep(/^[^.]/).map(&:split).transpose
      @col_groups = %i(ins states next_states outs).zip(cols).to_h
    end

    def circuit
      Circuit.from_fsm(ins:         put_cols_from(:ins),
                       outs:        put_cols_from(:outs),
                       states:      state_cols_from(:states),
                       next_states: state_cols_from(:next_states))
    end

    private_attr_reader :col_groups

    private

    def put_cols_from(name)
      rows = col_groups[name].map { |string| string.split('').map(&:to_sym) }
      Puts.from_columns(rows.transpose, codes: %i(0 1))
    end

    def state_codes
      (col_groups[:states] + col_groups[:next_states]).uniq.map(&:to_sym) - [:*]
    end

    def state_cols_from(name)
      column = col_groups[name].map { |state| state == '*' ? :- : state.to_sym }
      Puts.from_columns([column], codes: state_codes)
    end
  end
end
