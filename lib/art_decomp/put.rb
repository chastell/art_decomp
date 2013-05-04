module ArtDecomp class Put
  def self.[] blanket = {}
    new blanket: blanket
  end

  def initialize(blanket: {})
    @blanket = blanket
  end

  def == other
    blanket == other.blanket
  end

  def binwidth
    size.zero? ? 0 : Math.log2(size).ceil
  end

  def blocks
    blanket.values
  end

  def codes &block
    block_given? ? blanket.select(&block).keys : blanket.keys
  end

  def size
    blanket.size
  end

  attr_reader :blanket
  protected   :blanket
end end
