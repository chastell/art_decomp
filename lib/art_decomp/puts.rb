require 'equalizer'

module ArtDecomp
  class Puts
    include Enumerable
    include Equalizer.new(:puts)

    attr_reader :puts

    def initialize(puts = [])
      @puts = puts
    end

    def &(other)
      Puts.new(puts & other.puts)
    end

    def +(other)
      Puts.new(puts + other.puts)
    end

    def binwidth
      binwidths.reduce(0, :+)
    end

    def binwidths
      puts.map(&:binwidth)
    end

    def each(&block)
      puts.each(&block)
    end

    def empty?
      puts.empty?
    end

    def index(put)
      puts.index(put)
    end

    def size
      puts.size
    end
  end
end
