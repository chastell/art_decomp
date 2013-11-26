module ArtDecomp class CircuitSizer
  def initialize circuit
    @archs = circuit.function_archs.map { |arch| ArchSizer.new arch }
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

  attr_reader :archs
  private     :archs

  private

  def max_for_fitting
    archs.select(&:fits?).map(&:max_quarters)
  end

  def min_for_larger
    archs.reject(&:fits?).map(&:min_quarters)
  end

  class ArchSizer < SimpleDelegator
    def fits?
      i <= 8
    end

    def max_quarters
      case
      when i.zero?, o.zero? then 0
      when i <= 5           then (o / 2.0).ceil
      when i == 6           then o
      when i == 7           then o * 2
      when i == 8           then o * 4
      else
        o * (1 + 4 * self.class.new(Arch[i-2,1]).max_quarters)
      end
    end

    def min_quarters
      case
      when i.zero?, o.zero? then 0
      when i <= 5           then (o / 2.0).ceil
      else [(i / 5.0).ceil, (o / 2.0).ceil].max
      end
    end
  end
end end
