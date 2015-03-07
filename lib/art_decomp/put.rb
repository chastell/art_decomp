require 'anima'
require 'forwardable'
require_relative 'b'
require_relative 'seps'

module ArtDecomp
  class Put
    extend Forwardable
    include Anima.new(:codes, :column, :seps)

    def self.[](column = [], codes: column.uniq - [:-])
      new(column: column, codes: codes)
    end

    def self.from_column(column, codes:)
      new(column: column, codes: codes)
    end

    def initialize(column:, codes: column.uniq - [:-],
                   seps: Seps.from_column(column))
      @codes   = codes.sort
      @column  = column
      @seps    = seps
    end

    def binwidth
      size.zero? ? 0 : Math.log2(size).ceil
    end

    def inspect
      "#{self.class}#{column}"
    end

    delegate size: :codes
  end
end
