module ArtDecomp class Function
  attr_reader :is, :os

  def initialize is = [], os = []
    @is, @os = is.map(&:dup), os.map(&:dup)
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
