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
      adjusted_lines = composed.lines.map do |dst, src|
        case
        when function.ins.include?(dst)
          { decomposed.lines.invert[src] => src }
        when function.outs.include?(src)
          { dst => decomposed.lines[dst] }
        else
          { dst => src }
        end
      end.reduce({}, :merge)
      new_lines = decomposed.lines.reject do |dst, src|
        decomposed.own.ins.include?(src) or decomposed.own.outs.include?(dst)
      end
      lines = adjusted_lines.merge(new_lines)
      Circuit.new(functions: functions, lines: lines, own: composed.own)
    end

    private

    attr_reader :composed, :decomposed, :function

    def functions
      composed.functions - [function] + decomposed.functions
    end
  end
end
