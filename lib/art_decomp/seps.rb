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
    size   = Math.log2((blocks.max || 0) + 1).ceil
    ones   = (1 << size) - 1
    matrix = (0...size).map do |bit|
      ones ^ blocks.select { |block| block[bit] == 1 }.reduce(0, :|)
    end
    matrix.pop until matrix.empty? or matrix.last.nonzero?
    matrix
  end
end end
