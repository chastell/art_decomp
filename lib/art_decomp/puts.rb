require 'equalizer'
require 'forwardable'

module ArtDecomp
  class Puts
    extend  Forwardable
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

    delegate %i([] each empty? index size) => :puts

    def binwidth
      map(&:binwidth).reduce(0, :+)
    end
  end
end
