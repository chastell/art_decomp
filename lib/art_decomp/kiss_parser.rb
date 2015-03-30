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

    def puts
      in_block, state_block, next_block, out_block = blocks
      states = (state_block + next_block - ['*']).uniq.map(&:to_sym)
      {
        ins:         BlockParser.new(in_block).bin_puts,
        outs:        BlockParser.new(out_block).bin_puts,
        states:      BlockParser.new(state_block, codes: states).state_puts,
        next_states: BlockParser.new(next_block, codes: states).state_puts,
      }
    end

    class BlockParser
      def initialize(block, codes: %i(0 1))
        @block = block
        @codes = codes
      end

      def bin_puts
        cols = block.map { |row| row.split('').map(&:to_sym) }.transpose
        Puts.from_columns(cols, codes: codes)
      end

      def state_puts
        col = block.map { |state| state == '*' ? :- : state.to_sym }
        Puts.from_columns([col], codes: codes)
      end

      private_attr_reader :block, :codes
    end
  end
end
