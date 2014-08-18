module ArtDecomp
  class Puts
    attr_reader :is, :os, :ps, :qs

    def initialize is: [], os: [], ps: [], qs: []
      @is, @os, @ps, @qs = is, os, ps, qs
    end

    def binwidths group
      send(group).map(&:binwidth)
    end

    def eql? other
      [is, os, ps, qs].eql? [other.is, other.os, other.ps, other.qs]
    end

    alias_method :==, :eql?
  end
end
