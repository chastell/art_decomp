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
      (codes.size - 1).bit_length
    end

    def seps
      @seps ||= Seps.from_column(column)
    end

    delegate size: :column

    def state?
      false
    end
  end
end
