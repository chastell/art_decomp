require_relative 'circuit'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    def self.circuit_for(kiss)
      new(kiss).circuit
    end

    def initialize(kiss)
      @kiss = kiss
    end

    def circuit
      Circuit.from_fsm(puts)
    end

    private_attr_reader :kiss

    private

    def blocks
      kiss.lines.reject { |line| line.start_with?('.') }.map(&:split).transpose
    end

    def bin_puts_for(block)
      cols = block.map { |row| row.split('').map(&:to_sym) }.transpose
      Puts.from_columns(cols, codes: %i(0 1))
    end

    def puts
      ins, states, next_states, outs = blocks
      state_codes = (states + next_states - ['*']).uniq.map(&:to_sym)
      {
        ins:         bin_puts_for(ins),
        outs:        bin_puts_for(outs),
        states:      state_puts_for(states, codes: state_codes),
        next_states: state_puts_for(next_states, codes: state_codes),
      }
    end

    def state_puts_for(block, codes:)
      col = block.map { |state| state == '*' ? :- : state.to_sym }
      Puts.from_columns([col], codes: codes)
    end
  end
end
