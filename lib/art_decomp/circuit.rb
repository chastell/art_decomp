require 'anima'
require_relative 'archs_sizer'
require_relative 'function'
require_relative 'wires'

module ArtDecomp
  class Circuit
    class << self
      def from_function(function)
        wires = Wires.from_function(function)
        new(functions: [function], own: function, wires: wires)
      end
    end

    include Anima.new(:functions, :own, :wires)

    def initialize(archs_sizer: ArchSizer, **anima_attributes)
      super(**anima_attributes)
      @archs_sizer = archs_sizer
    end

    def admissible_size
      @admissible_size ||= archs_sizer.admissible(function_archs)
    end

    def largest_function
      functions.max_by(&:arch)
    end

    def max_size
      @max_size ||= archs_sizer.max(function_archs)
    end

    def min_size
      @min_size ||= archs_sizer.min(function_archs)
    end

    private

    attr_reader :archs_sizer

    def function_archs
      functions.map(&:arch)
    end
  end
end
