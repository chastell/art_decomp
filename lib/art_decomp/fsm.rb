require 'anima'
require_relative 'circuit'
require_relative 'function'
require_relative 'wires'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :recoders, :wires)

    def self.from_puts(ins:, outs:)
      function = Function.new(ins: ins, outs: outs)
      wires = Wirer.new(function, ins: ins, outs: outs).wires
      new(functions: [function], recoders: [], wires: wires)
    end

    # FIXME: figure out a way to inherit this
    def inspect
      "#{self.class}(#{function_archs})"
    end

    class Wirer < Wirer
      private

      def ins_wires
        Wires.from_array(ins.map.with_index do |put, n|
          offset = ins[0...n].map(&:binwidth).reduce(0, :+)
          source = if put.state?
                     [:circuit, :states, 0, put.binwidth, 0]
                   else
                     [:circuit, :ins, n, put.binwidth, offset]
                   end
          [source, [function, :ins, n, put.binwidth, offset]]
        end.compact)
      end

      def outs_wires
        Wires.from_array(outs.map.with_index do |put, n|
          offset = outs[0...n].map(&:binwidth).reduce(0, :+)
          target = if put.state?
                     [:circuit, :next_states, 0, put.binwidth, 0]
                   else
                     [:circuit, :outs, n, put.binwidth, offset]
                   end
          [[function, :outs, n, put.binwidth, offset], target]
        end.compact)
      end
    end
  end
end
