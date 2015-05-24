require_relative 'circuit'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :ins, :outs, :states, :next_states, :recoders,
                      :wires)

    def self.from_puts(ins:, outs:, states: Puts.new, next_states: Puts.new)
      function = Function.new(ins: ins, outs: outs)
      wires = Wirer.new(function, ins: ins, outs: outs).wires
      new(functions: [function], ins: ins, outs: outs, states: states,
          next_states: next_states, recoders: [], wires: wires)
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
          [[:circuit, :ins, n, put.binwidth],
           [function, :ins, n, put.binwidth]] unless put.state?
        end.compact)
      end

      def next_states_wires
        Wires.from_array(outs.map.with_index do |put, n|
          [[function, :outs,        n, put.binwidth],
           [:circuit, :next_states, 0, put.binwidth]] if put.state?
        end.compact)
      end

      def outs_wires
        Wires.from_array(outs.map.with_index do |put, n|
          [[function, :outs, n, put.binwidth],
           [:circuit, :outs, n, put.binwidth]] unless put.state?
        end.compact)
      end

      def states_wires
        Wires.from_array(ins.map.with_index do |put, n|
          [[:circuit, :states, 0, put.binwidth],
           [function, :ins,    n, put.binwidth]] if put.state?
        end.compact)
      end
    end
  end
end
