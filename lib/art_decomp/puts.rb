require 'anima'
require 'forwardable'
require_relative 'put'

module ArtDecomp
  class Puts
    extend Forwardable
    include Enumerable
    include Anima.new(:puts)

    def self.from_columns(columns, codes: nil)
      puts = columns.map do |column|
        Put.new(column: column, codes: codes || column.uniq - [:-])
      end
      new(puts)
    end

    def initialize(puts = [])
      @puts = puts
    end

    def &(other)
      self.class.new(puts & other.puts)
    end

    def +(other)
      self.class.new(puts + other.puts)
    end

    def [](index_or_range)
      case index_or_range
      when Integer then puts[index_or_range]
      when Range   then self.class.new(puts[index_or_range])
      end
    end

    delegate %i(each empty? index size) => :puts

    def binwidth
      map(&:binwidth).reduce(0, :+)
    end

    def seps
      puts.map(&:seps).reduce(:|)
    end

    def uniq
      self.class.new(puts.uniq)
    end
  end
end
