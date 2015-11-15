require 'anima'
require 'forwardable'
require_relative 'b'

module ArtDecomp
  class Seps
    extend Forwardable
    include Anima.new(:matrix)

    def self.from_column(column)               # rubocop:disable Metrics/AbcSize
      ones   = (1 << column.size) - 1
      coding = (0...column.size).group_by(&column.method(:[]))
      matrix = column.map do |code|
        code == :- ? 0 : ones & ~B[*coding[code]] & ~B[*coding[:-]]
      end
      new(matrix)
    end

    def initialize(matrix = [])
      @matrix = MatrixNormaliser.normalise(matrix)
    end

    # :reek:UncommunicativeVariableName
    def &(other)
      smaller, larger = [matrix, other.matrix].sort_by(&:size)
      self.class.new(smaller.zip(larger).map { |a, b| a & b })
    end

    # :reek:UncommunicativeVariableName
    def -(other)
      self.class.new(matrix.zip(other.matrix).map { |a, b| b ? a & ~b : a })
    end

    # :reek:UncommunicativeVariableName
    def |(other)
      smaller, larger = [matrix, other.matrix].sort_by(&:size)
      self.class.new(larger.zip(smaller).map { |a, b| b ? a | b : a })
    end

    def count
      popcounts.reduce(0, :+) / 2
    end

    delegate empty?: :matrix

    def inspect
      bits = matrix.map(&:bit_length).max
      rows = matrix.map { |int| "0b#{int.to_s(2).rjust(bits, '0')}" }
      "#{self.class}.new([#{rows.join(', ')}])"
    end

    def nonempty_by_popcount
      (0...matrix.size).reject { |row| matrix[row].zero? }
        .sort_by { |row| -popcounts[row] }
    end

    def separates?(row, col)
      matrix[row] and matrix[row][col].nonzero?
    end

    def seps_of(row)
      (0...matrix.size).select { |other| separates?(row, other) }
    end

    private

    def popcounts
      @popcounts ||= matrix.map { |int| int.to_s(2).count('1') }
    end

    module MatrixNormaliser
      module_function

      def normalise(matrix)
        matrix[0...(matrix.max || 0).bit_length]
      end
    end
  end
end
