require 'forwardable'

module ArtDecomp class Seps
  extend Forwardable

  def self.from_blocks blocks
    all  = blocks.reduce 0, :|
    size = Math.log2(all + 1).ceil
    ones = (1 << size) - 1
    blocks += [ones ^ all]
    matrix = (0...size).map do |bit|
      ones ^ blocks.select { |block| block[bit] == 1 }.reduce(0, :|)
    end
    new matrix
  end

  def self.normalise matrix
    matrix[0...Math.log2((matrix.max || 0) + 1).ceil]
  end

  def initialize matrix = []
    @matrix = self.class.normalise matrix
  end

  def & other
    smaller, larger = [matrix, other.matrix].sort_by(&:size)
    self.class.new smaller.zip(larger).map { |a, b| a & b }
  end

  def - other
    self.class.new matrix.zip(other.matrix).map { |a, b| b ? a & ~b : a }
  end

  def | other
    smaller, larger = [matrix, other.matrix].sort_by(&:size)
    self.class.new larger.zip(smaller).map { |a, b| b ? a | b : a }
  end

  delegate empty?: :matrix

  def eql? other
    matrix == other.matrix
  end

  alias_method :==, :eql?

  def inspect
    bits = matrix.map { |r| (0...r.to_s(2).size).select { |bit| r[bit] == 1 } }
    blocks = bits.map { |r| "B[#{r.join ','}]" }
    "#{self.class}.new [#{blocks.join ', '}]"
  end

  def size
    matrix.map { |int| int.to_s(2).count '1' }.reduce(0, :+) / 2
  end

  attr_reader :matrix
  protected   :matrix
end end
