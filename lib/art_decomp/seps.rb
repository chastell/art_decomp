module ArtDecomp class Seps
  def self.[] *blocks
    new blocks: blocks
  end

  def initialize blocks: []
    @blocks = blocks
  end

  def == other
    blocks == other.blocks
  end

  attr_reader :blocks
  protected   :blocks
end end
