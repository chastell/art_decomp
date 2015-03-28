require_relative 'circuit'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    def self.circuit_for(kiss)
      new(kiss).circuit
    end

    def initialize(kiss)
      order = %i(ins states next_states outs)
      @columns = order.zip(kiss.lines.grep(/^[^.]/).map(&:split).transpose).to_h
    end

    def circuit
      Circuit.from_fsm(ins:         bin_puts_for(:ins),
                       outs:        bin_puts_for(:outs),
                       states:      state_puts_for(:states),
                       next_states: state_puts_for(:next_states))
    end

    private_attr_reader :columns

    private

    def bin_puts_for(group)
      cols = columns[group].map { |row| row.split('').map(&:to_sym) }.transpose
      Puts.from_columns(cols, codes: %i(0 1))
    end

    def state_puts_for(group)
      col = columns[group].map { |state| state == '*' ? :- : state.to_sym }
      Puts.from_columns([col], codes: state_codes)
    end

    def state_codes
      (columns[:states] + columns[:next_states] - ['*']).uniq.map(&:to_sym)
    end
  end
end
