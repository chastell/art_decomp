require 'equalizer'
require_relative 'arch'

module ArtDecomp
  class Function
    include Equalizer.new(:is, :os)

    attr_reader :is, :os

    def initialize(is: Puts.new, os: Puts.new)
      @is, @os = is, os
    end

    def arch
      Arch[binwidths(:is).reduce(0, :+), binwidths(:os).reduce(0, :+)]
    end

    def binwidths(group)
      send(group).map(&:binwidth)
    end
  end
end
