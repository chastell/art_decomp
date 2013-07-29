module ArtDecomp class Function
  attr_reader :is, :os

  def initialize is = [], os = []
    @is, @os = is, os
  end

  def == other
    is == other.is and os == other.os
  end

  def arch
    Arch[binwidths(:is).reduce(0, :+), binwidths(:os).reduce(0, :+)]
  end

  def binwidth
    binwidths(:is).reduce 0, :+
  end

  def binwidths group
    send(group).map(&:binwidth)
  end
end end
