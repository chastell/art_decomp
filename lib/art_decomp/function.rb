module ArtDecomp class Function
  attr_reader :is, :os

  def initialize is, os
    @is = is
    @os = os
  end

  def widths group
    ss = { i: is, o: os }[group]
    ss.map { |s| width_of s }
  end
end end
