module ArtDecomp class Function
  attr_reader :is, :os

  def initialize is, os
    @is, @os = is, os
  end

  def width
    widths(:is).reduce 0, :+
  end

  def widths group
    send(group).map { |s| width_of s }
  end
end end
