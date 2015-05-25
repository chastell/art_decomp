require 'anima'
require_relative 'archs_sizer'
require_relative 'function'
require_relative 'wirer'

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
  end
end
