require 'anima'
require 'forwardable'

module ArtDecomp
  class Puts
    extend  Forwardable
    include Enumerable
    include Anima.new(:puts)

    def initialize(puts = [])
      @puts = puts
    end

    def &(other)
      Puts.new(puts & other.puts)
    end

    def +(other)
      Puts.new(puts + other.puts)
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
