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

    def self.from_column(col, codes: %i(0 1), dont_care: :-)
      blocks = codes.map do |code|
        B[*col.each_index.select { |i| col[i] == code or col[i] == dont_care }]
      end
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
