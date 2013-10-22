module ArtDecomp class Function
  attr_reader :puts

  def initialize puts = Puts.new
    @puts = puts
  end

  def == other
    puts == other.puts
  end

  def arch
    Arch[binwidths(:is).reduce(0, :+), binwidths(:os).reduce(0, :+)]
  end

  def binwidth
    binwidths(:is).reduce 0, :+
  end

  def binwidths group
    puts.send(group).map(&:binwidth)
  end
end end
