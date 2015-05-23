require_relative 'arch_sizer'

module ArtDecomp
  class ArchsSizer
    def self.adm_size(archs)
      new(archs).adm_size
    end

    def self.max_size(archs)
      new(archs).max_size
    end

    def self.min_size(archs)
      new(archs).min_size
    end

    def initialize(archs)
      @archs = archs.map { |arch| ArchSizer.new(arch) }
    end

    def adm_size
      ((max_for_fitting + min_for_larger).reduce(0, :+) / 4.0).ceil
    end

    def max_size
      (archs.map(&:max_quarters).reduce(0, :+) / 4.0).ceil
    end

    def min_size
      (archs.map(&:min_quarters).reduce(0, :+) / 4.0).ceil
    end

    private

    private_attr_reader :archs

    def max_for_fitting
      archs.select(&:fits?).map(&:max_quarters)
    end

    def min_for_larger
      archs.reject(&:fits?).map(&:min_quarters)
    end
  end
end
