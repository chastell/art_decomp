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

  def & other
    smaller, larger = [matrix, other.matrix].sort_by(&:size)
    new = smaller.zip(larger).map { |a, b| a & b }
    Seps.new matrix: normalise(new)
  end

  def + other
    smaller, larger = [matrix, other.matrix].sort_by(&:size)
    Seps.new matrix: larger.zip(smaller).map { |a, b| b ? a | b : a }
  end

  def empty?
    matrix.empty?
  end

  def inspect
    rows = matrix.map { |r| "0b#{r.to_s(2).rjust matrix.size, '0'}" }.join ', '
    "ArtDecomp::Seps.new matrix: [#{rows}]"
  end

  def size
    matrix.map { |int| int.to_s(2).count '1' }.reduce(0, :+) / 2
  end

  attr_reader :matrix
  protected   :matrix

  private

  def matrix_from blocks
    all    = blocks.reduce 0, :|
    size   = Math.log2(all + 1).ceil
    ones   = (1 << size) - 1
    blocks = blocks + [ones ^ all]
    matrix = (0...size).map do |bit|
      ones ^ blocks.select { |block| block[bit] == 1 }.reduce(0, :|)
    end
    normalise matrix
  end

  def normalise matrix
    matrix[0...Math.log2((matrix.max || 0) + 1).ceil]
  end
end end
