module ArtDecomp class Decompositions
  def self.for circuit, decomposer: CircuitDecomposer
    queue = [circuit]
    Enumerator.new do |yielder|
      until queue.empty?
        circuit = queue.shift
        yielder << circuit
        decomposer.decompose(circuit).each { |circ| queue << circ }
        queue.sort_by!(&:size)
      end
    end
  end
end end
