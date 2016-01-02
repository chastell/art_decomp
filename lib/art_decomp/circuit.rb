require 'anima'
require_relative 'archs_sizer'
require_relative 'function'
require_relative 'wirer'

module ArtDecomp
  class Circuit
    include Anima.new(:functions, :own, :wires)

    def self.from_function(function)
      wires = Wirer.wires(function, own: function)
      new(functions: [function], own: function, wires: wires)
    end

    def initialize(archs_sizer: ArchSizer, **anima_attributes)
      super(**anima_attributes)
      @archs_sizer = archs_sizer
    end

    def adm_size
      @adm_size ||= archs_sizer.adm_size(function_archs)
    end

    def largest_function
      functions.max_by(&:arch)
    end

    def max_size
      @max_size ||= archs_sizer.max_size(function_archs)
    end

    def min_size
      @min_size ||= archs_sizer.min_size(function_archs)
    end

    private

    attr_reader :archs_sizer

    def function_archs
      functions.map(&:arch)
    end
  end
end
