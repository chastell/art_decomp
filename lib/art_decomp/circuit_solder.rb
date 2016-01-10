require_relative 'circuit'
require_relative 'dst_pin'
require_relative 'src_pin'
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
      Circuit.new(functions: functions, lines: lines, own: composed.own,
                  wires: adjusted_wires + new_wires)
    end

    private

    attr_reader :composed, :decomposed, :function

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
      Wires.new(composed.wires.map(&method(:adjusted_wire)))
    end

    def destination_pin(wire)
      found = decomposed.wires.find do |dec_wire|
        source = dec_wire.source
        source.circuit? and source.puts == wire.destination.puts and
        source.put == wire.destination.put
      end
      found.destination
    end

    def functions
      composed.functions - [function] + decomposed.functions
    end

    def new_wires
      decomposed.wires.reject do |wire|
        wire.source.circuit? or wire.destination.circuit?
      end
    end

    def source_pin(wire)
      found = decomposed.wires.find do |dec_wire|
        destination = dec_wire.destination
        destination.circuit? and destination.puts == wire.source.puts and
        destination.put == wire.source.put
      end
      found.source
    end
  end
end
