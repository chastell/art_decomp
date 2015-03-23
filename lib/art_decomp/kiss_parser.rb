require_relative 'circuit'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    def self.circuit_for(kiss)
      new(kiss).circuit
    end

    def initialize(kiss)
      data_lines = kiss.lines.grep(/^[^.]/)
      @ins, @states, @next_states, @outs = data_lines.map(&:split).transpose
    end

    def circuit
      Circuit.from_fsm(ins:         put_cols_from(ins),
                       outs:        put_cols_from(outs),
                       states:      state_cols_from(states),
                       next_states: state_cols_from(next_states))
    end

    private_attr_reader :ins, :outs, :states, :next_states

    private

    def put_cols_from(group)
      rows = group.map { |string| string.split('').map(&:to_sym) }
      Puts.from_columns(rows.transpose, codes: %i(0 1))
    end

    def state_codes
      (states + next_states).uniq.map(&:to_sym) - [:*]
    end

    def state_cols_from(group)
      column = group.map { |state| state == '*' ? :- : state.to_sym }
      Puts.from_columns([column], codes: state_codes)
    end
  end
end
