require 'equalizer'

module ArtDecomp
  class Puts
    include Equalizer.new(:is, :os, :ps, :qs)

    attr_reader :is, :os, :ps, :qs

    def initialize(is: [], os: [], ps: [], qs: [])
      @is, @os, @ps, @qs = is, os, ps, qs
    end

    def binwidths(group)
      send(group).map(&:binwidth)
    end
  end
end
