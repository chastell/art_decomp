require 'anima'
require_relative 'circuit_sizer'
require_relative 'function'
require_relative 'wires'

module ArtDecomp
  class Circuit
    include Anima.new(:functions, :ins, :outs, :wires)
    include Anima::Update

    def self.from_puts(ins:, outs:)
      function = Function.new(ins: ins, outs: outs)
      wires = Wirer.new(function, ins: ins, outs: outs).wires
      new(functions: [function], ins: ins, outs: outs, wires: wires)
    end

    def adm_size(circuit_sizer: CircuitSizer)
      @adm_size ||= circuit_sizer.adm_size(function_archs)
    end

    def inspect
      "#{self.class}(#{function_archs})"
    end

    def largest_function
      functions.max_by(&:arch)
    end

    def max_size(circuit_sizer: CircuitSizer)
      @max_size ||= circuit_sizer.max_size(function_archs)
    end

    def min_size(circuit_sizer: CircuitSizer)
      @min_size ||= circuit_sizer.min_size(function_archs)
    end

    private

    def function_archs
      functions.map(&:arch)
    end

    class Wirer
      def initialize(function, ins:, outs:)
        @function, @ins, @outs = function, ins, outs
      end

      def wires
        ins_wires + outs_wires
      end

      private

      private_attr_reader :function, :ins, :outs

      def ins_wires
        Wires.from_array((0...ins.size).map do |n|
          [[:circuit, :ins, n], [function, :ins, n]]
        end)
      end

      def outs_wires
        Wires.from_array((0...outs.size).map do |n|
          [[function, :outs, n], [:circuit, :outs, n]]
        end)
      end
    end
  end
end
