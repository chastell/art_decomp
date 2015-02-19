require 'equalizer'
require_relative 'circuit_sizer'
require_relative 'function'
require_relative 'puts'
require_relative 'wires'

module ArtDecomp
  class Circuit
    include Equalizer.new(:functions, :is, :os, :ps, :qs, :recoders, :wires)

    attr_reader :functions, :is, :os, :ps, :qs, :recoders, :wires

    def self.from_fsm(is:, os:, ps:, qs:)
      function = Function.new(is: is + qs, os: os + ps)
      wires = Wirer.new(function, is: is, os: os).wires
      new(functions: [function], is: is, os: os, ps: ps, qs: qs, wires: wires)
    end

    def initialize(functions: [], is: Puts.new, os: Puts.new, ps: Puts.new,
                   qs: Puts.new, recoders: [], wires: Wires.new)
      @functions         = functions
      @is, @os, @ps, @qs = is, os, ps, qs
      @recoders          = recoders
      @wires             = wires
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
        is_wires + qs_wires + os_wires + ps_wires
      end

      private_attr_reader :function, :is, :os

      private

      def is_wires
        Wires.from_array((0...is.size).map do |n|
          [[:circuit, :is, n], [function, :is, n]]
        end)
      end

      def os_wires
        Wires.from_array((0...os.size).map do |n|
          [[function, :os, n], [:circuit, :os, n]]
        end)
      end

      def ps_wires
        Wires.from_array([[[function, :os, os.size], [:circuit, :ps, 0]]])
      end

      def qs_wires
        Wires.from_array([[[:circuit, :qs, 0], [function, :is, is.size]]])
      end
    end
  end
end
