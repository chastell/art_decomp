require 'anima'
require 'forwardable'
require_relative 'put'

module ArtDecomp
  class Puts
    extend Forwardable
    include Enumerable
    include Anima.new(:puts)

    def self.from_columns(columns, codes: columns.flatten.uniq - [:-])
      new(columns.map { |column| Put.new(column: column, codes: codes) })
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

    delegate %i([] each empty? index size) => :puts

    def binwidth
      map(&:binwidth).reduce(0, :+)
    end

    def uniq
      self.class.new(puts.uniq)
    end
  end
end
