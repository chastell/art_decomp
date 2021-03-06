require 'procto'
require_relative 'circuit_decomposer'

module ArtDecomp
  class Decomposer
    include Procto.call

    def initialize(circuit, circuit_decomposer:)
      @circuit_decomposer = circuit_decomposer
      @queue              = [circuit]
    end

    def call
      Enumerator.new do |yielder|
        until queue.empty?
          smallest = queue.shift
          yielder << smallest
          queue.concat circuit_decomposer.call(smallest)
          queue.sort_by!(&:admissible_size)
        end
      end
    end

    private

    attr_reader :circuit_decomposer, :queue
  end
end
