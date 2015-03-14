require 'anima'
require 'forwardable'

module ArtDecomp
  class Seps
    extend Forwardable
    include Anima.new(:matrix)

    def self.from_blocks(blocks)
      all  = blocks.reduce(0, :|)
      size = all.bit_length
      ones = (1 << size) - 1
      blocks += [ones ^ all]
      matrix = (0...size).map do |bit|
        ones ^ blocks.select { |block| block[bit] == 1 }.reduce(0, :|)
      end
      new(matrix)
    end

    def self.from_column(column)
      ones   = (1 << column.size) - 1
      coding = (0...column.size).group_by { |i| column[i] }
      matrix = column.map do |code|
        code == :- ? 0 : ones & ~B[*coding[code]] & ~B[*coding[:-]]
      end
      new(matrix)
    end

    def self.normalise(matrix)
      matrix[0...(matrix.max || 0).bit_length]
    end

    def initialize(matrix = [])
      @matrix = self.class.normalise(matrix)
    end

    def &(other)
      smaller, larger = [matrix, other.matrix].sort_by(&:size)
      self.class.new(smaller.zip(larger).map { |a, b| a & b })
    end

    def -(other)
      self.class.new(matrix.zip(other.matrix).map { |a, b| b ? a & ~b : a })
    end

    def |(other)
      smaller, larger = [matrix, other.matrix].sort_by(&:size)
      self.class.new(larger.zip(smaller).map { |a, b| b ? a | b : a })
    end

    def code_generator
      Enumerator.new do |yielder|
        code = :a
        loop do
          yielder << code
          code = code.next
        end
      end
    end

    delegate empty?: :matrix

    def inspect
      bits = matrix.map do |row|
        (0...row.to_s(2).size).select { |bit| row[bit] == 1 }
      end
      blocks = bits.map { |r| "B[#{r.join(',')}]" }
      "#{self.class}.new([#{blocks.join(', ')}])"
    end

    def size
      matrix.map { |int| int.to_s(2).count('1') }.reduce(0, :+) / 2
    end

    def to_column
      codes  = code_generator
      coding = matrix.uniq.reject(&:zero?).map { |int| [int, codes.next] }.to_h
      matrix.map { |int| coding.fetch(int, :-) }
    end
  end
end
