require 'anima'
require_relative 'circuit_sizer'
require_relative 'function'
require_relative 'puts'
require_relative 'wires'

module ArtDecomp
  class Circuit
    include Anima.new(:functions, :ins, :outs, :states, :next_states, :recoders,
                      :wires)

    def self.from_fsm(ins:, outs:, states:, next_states:)
      function = Function.new(ins: ins + states, outs: outs + next_states)
      wires = Wirer.new(function, ins: ins, outs: outs).wires
      new(functions: [function], ins: ins, outs: outs, states: states,
          next_states: next_states, wires: wires)
    end

    def initialize(functions: [], ins: Puts.new, outs: Puts.new,
                   states: Puts.new, next_states: Puts.new, recoders: [],
                   wires: Wires.new)
      @functions            = functions
      @ins, @outs              = ins, outs
      @states, @next_states = states, next_states
      @recoders             = recoders
      @wires                = wires
    end

    def adm_size(circuit_sizer: CircuitSizer.new(self))
      @adm_size ||= circuit_sizer.adm_size
    end

    def function_archs
      functions.map(&:arch)
    end

    def inspect
      "#{self.class}(#{function_archs})"
    end

    def largest_function
      functions.max_by(&:arch)
    end

    def max_size(circuit_sizer: CircuitSizer.new(self))
      @max_size ||= circuit_sizer.max_size
    end

    def min_size(circuit_sizer: CircuitSizer.new(self))
      @min_size ||= circuit_sizer.min_size
    end

    class Wirer
      def initialize(function, ins:, outs:)
        @function, @ins, @outs = function, ins, outs
      end

      def wires
        ins_wires + states_wires + outs_wires + next_states_wires
      end

      private_attr_reader :function, :ins, :outs

      private

      def ins_wires
        Wires.from_array((0...ins.size).map do |n|
          [[:circuit, :ins, n], [function, :ins, n]]
        end)
      end

      def next_states_wires
        Wires.from_array([[[function, :outs, outs.size],
                           [:circuit, :next_states, 0]]])
      end

      def outs_wires
        Wires.from_array((0...outs.size).map do |n|
          [[function, :outs, n], [:circuit, :outs, n]]
        end)
      end

      def states_wires
        Wires.from_array([[[:circuit, :states, 0], [function, :ins, ins.size]]])
      end
    end
  end
end
