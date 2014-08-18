require_relative 'circuit_decomposer'

module ArtDecomp
  module Decomposer
    def self.decompose_circuit circuit, circuit_decomposer: CircuitDecomposer
      queue = [circuit]
      Enumerator.new do |yielder|
        until queue.empty?
          smallest = queue.shift
          yielder << smallest
          queue.concat circuit_decomposer.decompose smallest
          queue.sort_by!(&:adm_size)
        end
      end
    end
  end
end
