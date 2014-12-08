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

    def each(&block)
      puts.each(&block)
    end

    def empty?
      puts.empty?
    end

    def index(index)
      puts.index(index)
    end

    def size
      puts.size
    end
  end
end
