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
    new.pop until new.empty? or new.last.nonzero?
    Seps.new matrix: new
  end

  def inspect
    rows = matrix.map { |r| "0b#{r.to_s(2).rjust matrix.size, '0'}" }.join ', '
    "ArtDecomp::Seps.new matrix: [#{rows}]"
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
    matrix.pop until matrix.empty? or matrix.last.nonzero?
    matrix
  end
end end
