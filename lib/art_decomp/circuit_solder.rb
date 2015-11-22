require_relative 'circuit'
require_relative 'pin'
require_relative 'wire'
require_relative 'wires'

module ArtDecomp
  class CircuitSolder
    def self.replace(composed:, decomposed:, function:)
      cs = new(composed: composed, decomposed: decomposed, function: function)
      cs.replaced
    end

    def initialize(composed:, decomposed:, function:)
      @composed   = composed
      @decomposed = decomposed
      @function   = function
    end

    def replaced
      Circuit.new(functions: functions, wires: adjusted_wires + new_wires)
    end

    private

    private_attr_reader :composed, :decomposed, :function

    def adjusted_wire(wire)
      case
      when wire.destination.object == function
        Wire.new(source: wire.source, destination: destination_pin(wire))
      when wire.source.object == function
        Wire.new(source: source_pin(wire), destination: wire.destination)
      else
        wire
      end
    end

    def adjusted_wires
      Wires.new(composed.wires.map { |wire| adjusted_wire(wire) })
    end

    def destination_pin(wire)
      found = decomposed.wires.find do |dw|
        destination = wire.destination
        dw.source == SrcPin[:circuit, destination.puts, destination.put]
      end
      found.destination
    end

    def functions
      composed.functions - [function] + decomposed.functions
    end

    def new_wires
      decomposed.wires.reject do |wire|
        wire.source.object == :circuit or wire.destination.object == :circuit
      end
    end

    def source_pin(wire)
      found = decomposed.wires.find do |dw|
        dw.destination == DstPin[:circuit, wire.source.puts, wire.source.put]
      end
      found.source
    end
  end
end
