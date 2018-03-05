require_relative 'circuit'
require_relative 'function'
require_relative 'put'
require_relative 'puts'

module ArtDecomp
  class KISSParser
    class << self
      def circuit(kiss)
        new(kiss).circuit
      end

      def function(kiss)
        new(kiss).function
      end
    end

    def initialize(kiss)
      @kiss = kiss
    end

    def circuit
      Circuit.from_function(function)
    end

    def function
      Function.new(puts)
    end

    private

    attr_reader :kiss

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
      def initialize(block, codes: nil)
        @block = block
        @codes = codes
      end

      def puts
        cols = block.map { |row| row.split('').map(&:to_sym) }.transpose
        puts = cols.map do |column|
          Put.new(column: column, codes: codes || column.uniq - [:-])
        end
        Puts.new(puts)
      end

      private

      attr_reader :block, :codes
    end
    private_constant :BlockParser
  end
end
