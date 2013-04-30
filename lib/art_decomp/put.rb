module ArtDecomp class Put
  def self.[] blanket
    new blanket: blanket
  end

  def initialize(blanket: blanket)
    @blanket = blanket
  end

  def == other
    blanket == other.blanket
  end

  def size
    blanket.size
  end

  def values
    blanket.values
  end

  attr_reader :blanket
  protected   :blanket
end end
