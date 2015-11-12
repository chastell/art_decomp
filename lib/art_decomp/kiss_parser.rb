require_relative 'circuit'
require_relative 'function'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    def self.circuit_for(kiss)
      new(kiss).circuit
    end

    def self.function_for(kiss)
      new(kiss).function
    end

    def initialize(kiss)
      @kiss = kiss
    end

    def circuit
      Circuit.from_puts(puts)
    end

    def function
      Function.new(puts)
    end

    private

    private_attr_reader :kiss

    def blocks
      kiss.lines.reject { |line| line.start_with?('.') }.map(&:split).transpose
    end

    def puts
      in_block, out_block = blocks
      {
        ins:  BlockParser.new(in_block).puts,
        outs: BlockParser.new(out_block).puts,
      }
    end

    class BlockParser
      def initialize(block, codes: %i(0 1))
        @block = block
        @codes = codes
      end

      def puts
        cols = block.map { |row| row.split('').map(&:to_sym) }.transpose
        Puts.from_columns(cols, codes: codes)
      end

      private_attr_reader :block, :codes
    end
  end
end
