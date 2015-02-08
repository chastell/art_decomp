require_relative 'arch_sizer'

module ArtDecomp
  class CircuitSizer
    def initialize(circuit)
      @archs = circuit.function_archs.map { |arch| ArchSizer.new(arch) }
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

    private_attr_reader :archs

    private

    def max_for_fitting
      archs.select(&:fits?).map(&:max_quarters)
    end

    def min_for_larger
      archs.reject(&:fits?).map(&:min_quarters)
    end
  end
end
