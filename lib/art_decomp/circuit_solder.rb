require_relative 'circuit'
require_relative 'wires'

module ArtDecomp
  class CircuitSolder
    def self.call(composed:, decomposed:, function:)
      new(composed: composed, decomposed: decomposed, function: function).call
    end

    def initialize(composed:, decomposed:, function:)
      @composed   = composed
      @decomposed = decomposed
      @function   = function
    end

    def call
      wires = adjusted_wires + new_wires
      Circuit.new(functions: functions, own: composed.own, wires: wires)
    end

    private

    attr_reader :composed, :decomposed, :function

    def adjusted_wire(dst, src)
      case
      when function.ins.include?(dst)
        { decomposed.wires.invert[src] => src }
      when function.outs.include?(src)
        { dst => decomposed.wires[dst] }
      else
        { dst => src }
      end
    end

    def adjusted_wires
      hashes = composed.wires.map { |dst, src| adjusted_wire(dst, src) }
      Wires.new(hashes.reduce({}, :merge))
    end

    def functions
      composed.functions - [function] + decomposed.functions
    end

    def new_wires
      decomposed.wires.reject do |dst, src|
        decomposed.own.ins.include?(src) or decomposed.own.outs.include?(dst)
      end
    end
  end
end
