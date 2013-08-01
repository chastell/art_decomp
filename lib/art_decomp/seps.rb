module ArtDecomp class Seps
  def self.[] *blocks
    new blocks: blocks
  end

  def initialize blocks: [], matrix: nil
    @matrix = matrix || matrix_from(blocks)
  end

  def == other
    matrix == other.matrix
  end

  attr_reader :matrix
  protected   :matrix

  private

  def matrix_from blocks
    size = (blocks.max || 0).to_s(2).size
    ones = (1 << size) - 1
    (0...size).map do |bit|
      ones ^ blocks.select { |block| block[bit] == 1 }.reduce(0, :|)
    end
  end
end end
