require_relative 'circuit_decomposer'

module ArtDecomp
  class Decomposer
    def self.decompositions(circuit, circuit_decomposer: CircuitDecomposer)
      new(circuit, circuit_decomposer: circuit_decomposer).decompositions
    end

    def initialize(circuit, circuit_decomposer:)
      @circuit_decomposer = circuit_decomposer
      @queue              = [circuit]
    end

    def decompositions
      Enumerator.new do |yielder|
        until queue.empty?
          smallest = queue.shift
          yielder << smallest
          queue.concat circuit_decomposer.decompose(smallest)
          queue.sort_by!(&:adm_size)
        end
      end
    end

    private_attr_reader :circuit_decomposer, :queue
  end
end
