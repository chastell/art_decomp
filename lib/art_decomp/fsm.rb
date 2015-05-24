require_relative 'circuit'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :ins, :outs, :recoders, :wires)

    def self.from_puts(ins:, outs:)
      function = Function.new(ins: ins, outs: outs)
      wires = Wirer.new(function, ins: ins, outs: outs).wires
      new(functions: [function], ins: ins, outs: outs, recoders: [],
          wires: wires)
    end

    # FIXME: figure out a way to inherit this
    def inspect
      "#{self.class}(#{function_archs})"
    end

    class Wirer < Wirer
      def wires
        ins_wires + states_wires + outs_wires + next_states_wires
      end

      private

      def ins_wires
        Wires.from_array(ins.map.with_index do |put, n|
          offset = ins[0...n].map(&:binwidth).reduce(0, :+)
          [[:circuit, :ins, n, put.binwidth, offset],
           [function, :ins, n, put.binwidth, offset]] unless put.state?
        end.compact)
      end

      def next_states_wires
        offset = 0
        Wires.from_array(outs.map.with_index do |put, n|
          offset = outs[0...n].map(&:binwidth).reduce(0, :+)
          [[function, :outs,        n, put.binwidth, offset],
           [:circuit, :next_states, 0, put.binwidth, 0]] if put.state?
        end.compact)
      end

      def outs_wires
        offset = 0
        Wires.from_array(outs.map.with_index do |put, n|
          offset = outs[0...n].map(&:binwidth).reduce(0, :+)
          [[function, :outs, n, put.binwidth, offset],
           [:circuit, :outs, n, put.binwidth, offset]] unless put.state?
        end.compact)
      end

      def states_wires
        offset = 0
        Wires.from_array(ins.map.with_index do |put, n|
          offset = ins[0...n].map(&:binwidth).reduce(0, :+)
          [[:circuit, :states, 0, put.binwidth, 0],
           [function, :ins,    n, put.binwidth, offset]] if put.state?
        end.compact)
      end
    end
  end
end
