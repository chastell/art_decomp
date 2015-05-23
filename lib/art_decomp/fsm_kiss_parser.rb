require_relative 'fsm'
require_relative 'kiss_parser'
require_relative 'puts'
require_relative 'state_put'

module ArtDecomp
  class FSMKISSParser < KISSParser
    def circuit
      FSM.from_puts(puts)
    end

    private

    def puts
      in_block, state_block, next_block, out_block = blocks
      states = (state_block + next_block - ['*']).uniq.map(&:to_sym)
      {
        ins:         BlockParser.new(in_block).puts,
        outs:        BlockParser.new(out_block).puts,
        states:      BlockParser.new(state_block, codes: states).state_puts,
        next_states: BlockParser.new(next_block, codes: states).state_puts,
      }
    end

    class BlockParser < BlockParser
      def state_puts
        col = block.map { |state| state == '*' ? :- : state.to_sym }
        Puts.new([StatePut[col, codes: codes]])
      end
    end
  end
end
