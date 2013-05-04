module ArtDecomp class Decompositions
  def self.for circuit
    new(circuit).decompositions
  end

  def initialize circuit, decomposer: nil
    @decomposer = decomposer
    @queue      = [circuit]
  end

  def decompositions
    Enumerator.new do |yielder|
      until queue.empty?
        circuit = queue.shift
        yielder << circuit
        decomposer.decomposed(circuit).each { |circ| queue << circ }
        queue.sort_by!(&:not_smaller_than)
      end
    end
  end

  attr_reader :decomposer, :queue
  private     :decomposer, :queue
end end
