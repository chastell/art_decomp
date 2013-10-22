module ArtDecomp class Puts
  attr_reader :is, :os, :ps, :qs

  def initialize is: [], os: [], ps: [], qs: []
    @is, @os, @ps, @qs = is, os, ps,qs
  end

  def == other
    [is, os, ps, qs] == [other.is, other.os, other.ps, other.qs]
  end
end end
