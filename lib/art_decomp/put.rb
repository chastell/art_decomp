require 'anima'
require 'forwardable'
require_relative 'b'
require_relative 'seps'

module ArtDecomp
  class Put
    extend Forwardable
    include Anima.new(:column, :seps)

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
      @column  = column_from(blanket)
      @seps    = Seps.from_blocks(blanket.values)
    end

    def binwidth
      size.zero? ? 0 : Math.log2(size).ceil
    end

    def codes
      column.uniq - [:-]
    end

    def inspect
      "#{self.class}#{column}"
    end

    delegate size: :codes

    private

    def column_from(blanket)
      return [] if blanket.empty?
      Array.new(blanket.values.max.to_s(2).size) do |row|
        row_codes = blanket.reject { |_, int| (int & B[row]).zero? }.keys.sort
        case row_codes.size
        when blanket.size then :-
        when 1            then row_codes.first
        else fail 'trying to map multiple (but not all) codes'
        end
      end
    end
  end
end
