require 'anima'
require 'equalizer'
require_relative 'archs_sizer'
require_relative 'function'

module ArtDecomp
  class Circuit
    include Anima.new(:functions, :lines, :own)
    include Equalizer.new(:functions, :own)

    def self.from_function(function)
      in_lines  = function.ins.map  { |put| { put => put } }
      out_lines = function.outs.map { |put| { put => put } }
      lines     = (in_lines + out_lines).reduce({}, :merge)
      new(functions: [function], lines: lines, own: function)
    end

    def initialize(archs_sizer: ArchSizer, **anima_attributes)
      super(**anima_attributes)
      @archs_sizer = archs_sizer
    end

    def ==(other)
      super and lines.keys == other.lines.keys and
        lines.values == other.lines.values
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
