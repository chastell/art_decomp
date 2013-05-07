module ArtDecomp class Decompositions
  def self.for circuit
    new(circuit).decompositions
  end

  def initialize circuit
    @queue = [circuit]
  end

  def decompositions(decomposer: CircuitDecomposer)
    Enumerator.new do |yielder|
      until queue.empty?
        circuit = queue.shift
        yielder << circuit
        decomposer.decomposed(circuit).each { |circ| queue << circ }
        queue.sort_by!(&:size)
      end
    end
  end

  attr_reader :queue
  private     :queue
end end
