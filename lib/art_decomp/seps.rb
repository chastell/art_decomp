module ArtDecomp class Seps
  extend Forwardable

  def self.[] *blocks
    new blocks: blocks
  end

  def initialize blocks: [], matrix: matrix_from(blocks)
    @matrix = matrix[0...Math.log2((matrix.max || 0) + 1).ceil]
  end

  def & other
    smaller, larger = [matrix, other.matrix].sort_by(&:size)
    Seps.new matrix: smaller.zip(larger).map { |a, b| a & b }
  end

  def - other
    Seps.new matrix: matrix.zip(other.matrix).map { |a, b| b ? a & ~b : a }
  end

  def == other
    matrix == other.matrix
  end

  def | other
    smaller, larger = [matrix, other.matrix].sort_by(&:size)
    Seps.new matrix: larger.zip(smaller).map { |a, b| b ? a | b : a }
  end

  delegate empty?: :matrix

  def inspect
    bits = matrix.map { |r| (0...r.to_s(2).size).select { |bit| r[bit] == 1 } }
    blocks = bits.map { |r| "B[#{r.join ','}]" }
    "#{self.class}.new matrix: [#{blocks.join ', '}]"
  end

  def size
    matrix.map { |int| int.to_s(2).count '1' }.reduce(0, :+) / 2
  end

  attr_reader :matrix
  protected   :matrix

  private

  def matrix_from blocks
    all  = blocks.reduce 0, :|
    size = Math.log2(all + 1).ceil
    ones = (1 << size) - 1
    blocks += [ones ^ all]
    (0...size).map do |bit|
      ones ^ blocks.select { |block| block[bit] == 1 }.reduce(0, :|)
    end
  end
end end
