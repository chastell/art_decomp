require_relative 'circuit'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :ins, :outs, :states, :next_states, :recoders,
                      :wires)

    def self.from_puts(ins:, outs:, states: Puts.new, next_states: Puts.new)
      function = Function.new(ins: ins + states, outs: outs + next_states)
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

      def next_states_wires
        Wires.from_array([[[function, :outs, outs.size],
                           [:circuit, :next_states, 0]]])
      end

      def states_wires
        Wires.from_array([[[:circuit, :states, 0], [function, :ins, ins.size]]])
      end
    end
  end
end
