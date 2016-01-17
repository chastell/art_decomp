require_relative 'arch_sizer'

module ArtDecomp
  class ArchsSizer
    def self.admissible(archs)
      new(archs).admissible
    end

    def self.max(archs)
      new(archs).max
    end

    def self.min(archs)
      new(archs).min
    end

    def initialize(archs)
      @archs = archs.map { |arch| ArchSizer.new(arch) }
    end

    def admissible
      ((max_for_fitting + min_for_larger).reduce(0, :+) / 4.0).ceil
    end

    def max
      (archs.map(&:max_quarters).reduce(0, :+) / 4.0).ceil
    end

    def min
      (archs.map(&:min_quarters).reduce(0, :+) / 4.0).ceil
    end

    private

    attr_reader :archs

    def max_for_fitting
      archs.select(&:fits?).map(&:max_quarters)
    end

    def min_for_larger
      archs.reject(&:fits?).map(&:min_quarters)
    end
  end
end
