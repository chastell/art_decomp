module ArtDecomp class Seps
  def self.[] *blocks
    new blocks: blocks
  end

  def initialize blocks: []
    @matrix = matrix_from blocks
  end

  def == other
    matrix == other.matrix
  end

  attr_reader :matrix
  protected   :matrix

  private

  def matrix_from blocks
    blocks.sort
  end
end end
