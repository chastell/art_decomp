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
      Arch[is.binwidths.reduce(0, :+), os.binwidths.reduce(0, :+)]
    end
  end
end
