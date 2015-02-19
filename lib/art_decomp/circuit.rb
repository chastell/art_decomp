require 'equalizer'
require_relative 'circuit_sizer'
require_relative 'function'
require_relative 'puts'
require_relative 'wires'

module ArtDecomp
  class Circuit
    include Equalizer.new(:functions, :is, :os, :states, :next_states,
                          :recoders, :wires)

    attr_reader :functions, :is, :os, :states, :next_states, :recoders, :wires

    def self.from_fsm(is:, os:, states:, next_states:)
      function = Function.new(is: is + states, os: os + next_states)
      wires = Wirer.new(function, is: is, os: os).wires
      new(functions: [function], is: is, os: os, states: states,
          next_states: next_states, wires: wires)
    end

    def initialize(functions: [], is: Puts.new, os: Puts.new, states: Puts.new,
                   next_states: Puts.new, recoders: [], wires: Wires.new)
      @functions            = functions
      @is, @os              = is, os
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
      def initialize(function, is:, os:)
        @function, @is, @os = function, is, os
      end

      def wires
        is_wires + states_wires + os_wires + next_states_wires
      end

      private_attr_reader :function, :is, :os

      private

      def is_wires
        Wires.from_array((0...is.size).map do |n|
          [[:circuit, :is, n], [function, :is, n]]
        end)
      end

      def next_states_wires
        Wires.from_array([[[function, :os, os.size],
                           [:circuit, :next_states, 0]]])
      end

      def os_wires
        Wires.from_array((0...os.size).map do |n|
          [[function, :os, n], [:circuit, :os, n]]
        end)
      end

      def states_wires
        Wires.from_array([[[:circuit, :states, 0], [function, :is, is.size]]])
      end
    end
  end
end
