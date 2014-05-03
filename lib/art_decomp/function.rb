module ArtDecomp class Function
  extend Forwardable

  attr_reader :puts

  def initialize puts = Puts.new
    @puts = puts
  end

  def arch
    Arch[binwidths(:is).reduce(0, :+), binwidths(:os).reduce(0, :+)]
  end

  def eql? other
    puts == other.puts
  end

  alias_method :==, :eql?

  delegate %i(binwidths is os) => :puts
end end
