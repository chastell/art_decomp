require 'anima'
require_relative 'archs_sizer'
require_relative 'function'
require_relative 'wires'

module ArtDecomp
  class Circuit
    include Anima.new(:functions, :wires)
    include Anima::Update

    def self.from_puts(ins:, outs:)
      function = Function.new(ins: ins, outs: outs)
      wires = Wirer.new(function, ins: ins, outs: outs).wires
      new(functions: [function], wires: wires)
    end

    def adm_size(archs_sizer: ArchsSizer)
      @adm_size ||= archs_sizer.adm_size(function_archs)
    end

    def inspect
      "#{self.class}(#{function_archs})"
    end

    def largest_function
      functions.max_by(&:arch)
    end

    def max_size(archs_sizer: ArchsSizer)
      @max_size ||= archs_sizer.max_size(function_archs)
    end

    def min_size(archs_sizer: ArchsSizer)
      @min_size ||= archs_sizer.min_size(function_archs)
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
        Wires.from_array(ins.map.with_index do |put, n|
          offset = ins[0...n].map(&:binwidth).reduce(0, :+)
          [[:circuit, :ins, n, put.binwidth, offset],
           [function, :ins, n, put.binwidth, offset]]
        end)
      end

      def outs_wires
        Wires.from_array(outs.map.with_index do |put, n|
          offset = outs[0...n].map(&:binwidth).reduce(0, :+)
          [[function, :outs, n, put.binwidth, offset],
           [:circuit, :outs, n, put.binwidth, offset]]
        end)
      end
    end
  end
end
