require 'anima'
require 'forwardable'

module ArtDecomp
  class Seps
    extend Forwardable
    include Anima.new(:matrix)

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
      bits = matrix.map(&:bit_length).max
      rows = matrix.map { |int| "0b#{int.to_s(2).rjust(bits, '0')}" }
      "#{self.class}.new([#{rows.join(', ')}])"
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
