# frozen_string_literal: true

require 'anima'
require 'forwardable'
require_relative 'seps'

module ArtDecomp
  class Put
    class << self
      def [](column, codes: column.uniq - [:-])
        new(column: column, codes: codes)
      end
    end

    extend Forwardable
    include Anima.new(:codes, :column)

    def initialize(column:, codes: column.uniq - [:-])
      @codes  = codes.sort
      @column = column
    end

    def <=>(other)
      (column <=> other.column).nonzero? or codes <=> other.codes
    end

    def binwidth
      (codes.size - 1).bit_length
    end

    alias eql? equal?
    alias hash object_id

    def seps
      @seps ||= Seps.from_column(column)
    end

    delegate size: :column

    def state?
      false
    end
  end
end
