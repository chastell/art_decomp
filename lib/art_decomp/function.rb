module ArtDecomp class Function
  attr_reader :is, :os

  def initialize is, os
    @is = is
    @os = os
  end

  def width
    widths(:is).reduce 0, :+
  end

  def widths group
    ss = { is: is, os: os }[group]
    ss.map { |s| width_of s }
  end
end end
