module ArtDecomp class Function
  extend Forwardable

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

  def_delegator :puts, :binwidths
end end
