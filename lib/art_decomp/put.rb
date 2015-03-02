require 'anima'
require 'forwardable'
require_relative 'b'
require_relative 'seps'

module ArtDecomp
  class Put
    extend Forwardable
    include Anima.new(:blanket, :seps)

    def self.[](blanket = {})
      new(blanket: blanket)
    end

    def self.from_column(column, codes:, dont_care:)
      indices = (0...column.size).group_by { |i| column[i] }
      blocks  = codes.map { |code| B[*indices[code]] | B[*indices[dont_care]] }
      new(blanket: codes.zip(blocks).to_h)
    end

    def initialize(blanket:)
      @blanket = blanket
      @seps    = Seps.from_blocks(blanket.values)
    end

    def binwidth
      size.zero? ? 0 : Math.log2(size).ceil
    end

    def blocks
      blanket.values
    end

    def codes(&block)
      block_given? ? blanket.select(&block).keys : blanket.keys
    end

    def inspect
      blocks = blanket.map do |key, block|
        bits = (0...block.to_s(2).size).select { |bit| block[bit] == 1 }
        "#{key.inspect} => B[#{bits.join ','}]"
      end
      "#{self.class}[#{blocks.join ', '}]"
    end

    delegate size: :blanket
  end
end
