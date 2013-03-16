module ArtDecomp class Function
  attr_reader :is, :os

  def initialize is, os
    @is = is
    @os = os
  end

  def width
    widths(:i).reduce 0, :+
  end

  def widths group
    ss = { i: is, o: os }[group]
    ss.map { |s| width_of s }
  end
end end
