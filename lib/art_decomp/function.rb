require 'equalizer'
require 'forwardable'
require_relative 'arch'
require_relative 'puts_set'

module ArtDecomp
  class Function
    extend Forwardable

    include Equalizer.new(:puts_set)

    attr_reader :puts_set

    def initialize(puts_set = PutsSet.new)
      @puts_set = puts_set
    end

    def arch
      Arch[binwidths(:is).reduce(0, :+), binwidths(:os).reduce(0, :+)]
    end

    delegate %i(binwidths is os) => :puts_set
  end
end
