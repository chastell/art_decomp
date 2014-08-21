require 'equalizer'
require 'forwardable'
require_relative 'arch'
require_relative 'puts'

module ArtDecomp
  class Function
    extend Forwardable

    include Equalizer.new :puts

    attr_reader :puts

    def initialize(puts = Puts.new)
      @puts = puts
    end

    def arch
      Arch[binwidths(:is).reduce(0, :+), binwidths(:os).reduce(0, :+)]
    end

    delegate %i(binwidths is os) => :puts
  end
end
