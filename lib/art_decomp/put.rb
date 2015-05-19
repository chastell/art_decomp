require 'anima'
require 'forwardable'
require_relative 'seps'

module ArtDecomp
  class Put
    extend Forwardable
    include Anima.new(:codes, :column)

    def self.[](column, codes: column.uniq - [:-])
      new(column: column, codes: codes)
    end

    def initialize(column:, codes: column.uniq - [:-])
      @codes  = codes.sort
      @column = column
    end

    def binwidth
      (size - 1).bit_length
    end

    def inspect
      "#{self.class}#{column}"
    end

    def seps
      @seps ||= Seps.from_column(column)
    end

    delegate size: :codes
  end
end
