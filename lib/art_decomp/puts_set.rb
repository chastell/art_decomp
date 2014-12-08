require 'equalizer'
require_relative 'puts'

module ArtDecomp
  class PutsSet
    include Equalizer.new(:is, :os, :ps, :qs)

    attr_reader :is, :os, :ps, :qs

    def initialize(is: Puts.new, os: Puts.new, ps: Puts.new, qs: Puts.new)
      @is, @os, @ps, @qs = is, os, ps, qs
    end

    def binwidths(group)
      send(group).map(&:binwidth)
    end
  end
end
