module ArtDecomp class Decompositions
  def for circuit, circuit_decomposer: CircuitDecomposer.new
    queue = [circuit]
    Enumerator.new do |yielder|
      until queue.empty?
        circuit = queue.shift
        yielder << circuit
        circuit_decomposer.decompose(circuit).each { |circ| queue << circ }
        queue.sort_by!(&:min_size)
      end
    end
  end
end end
