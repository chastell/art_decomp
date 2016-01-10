require_relative 'circuit'

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
      adjusted_wires = composed.wires.map do |dst, src|
        case
        when function.ins.include?(dst)
          { decomposed.wires.invert[src] => src }
        when function.outs.include?(src)
          { dst => decomposed.wires[dst] }
        else
          { dst => src }
        end
      end.reduce({}, :merge)
      new_wires = decomposed.wires.reject do |dst, src|
        decomposed.own.ins.include?(src) or decomposed.own.outs.include?(dst)
      end
      wires = adjusted_wires.merge(new_wires)
      Circuit.new(functions: functions, own: composed.own, wires: wires)
    end

    private

    attr_reader :composed, :decomposed, :function

    def functions
      composed.functions - [function] + decomposed.functions
    end
  end
end
