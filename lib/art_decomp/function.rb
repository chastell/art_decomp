module ArtDecomp class Function
  attr_reader :is, :os

  def initialize is, os
    @is, @os = is.map(&:dup), os.map(&:dup)
  end

  def width
    widths(:is).reduce 0, :+
  end

  def widths group
    send(group).map(&:width)
  end
end end
