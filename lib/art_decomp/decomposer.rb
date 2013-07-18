module ArtDecomp class Decomposer
  def for circuit, circuit_decomposer: CircuitDecomposer.new
    queue = [circuit]
    Enumerator.new do |yielder|
      until queue.empty?
        circuit = queue.shift
        yielder << circuit
        circuit_decomposer.decompose(circuit).each { |circ| queue << circ }
        queue.sort_by!(&:adm_size)
      end
    end
  end
end end
