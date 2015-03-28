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
      order = %i(ins states next_states outs)
      order.zip(kiss.lines.grep(/^[^.]/).map(&:split).transpose).to_h
    end

    def codes(type)
      case type
      when :bin
        %i(0 1)
      when :state
        (blocks[:states] + blocks[:next_states] - ['*']).uniq.map(&:to_sym)
      end
    end

    def cols(type, block)
      case type
      when :bin
        block.map { |row| row.split('').map(&:to_sym) }.transpose
      when :state
        [block.map { |state| state == '*' ? :- : state.to_sym }]
      end
    end

    def puts
      types = { ins: :bin, states: :state, next_states: :state, outs: :bin }
      types.map do |group, type|
        block = blocks[group]
        [group, Puts.from_columns(cols(type, block), codes: codes(type))]
      end.to_h
    end
  end
end
