module ArtDecomp class CircuitSizer
  def initialize circuit
    @archs = circuit.function_archs
  end

  def adm_size
    max, min = archs.partition { |arch| arch.i <= 8 }
    quarters = max.map { |a| max_quarters a } + min.map { |a| min_quarters a }
    (quarters.reduce(0, :+) / 4.0).ceil
  end

  def max_size
    (archs.map { |arch| max_quarters arch }.reduce(0, :+) / 4.0).ceil
  end

  def min_size
    (archs.map { |arch| min_quarters arch }.reduce(0, :+) / 4.0).ceil
  end

  attr_reader :archs
  private     :archs

  private

  def max_quarters arch
    i, o = *arch
    case
    when i == 0 then 0
    when i <= 5 then (o / 2.0).ceil
    when i == 6 then o
    when i == 7 then o * 2
    when i == 8 then o * 4
    else o * (max_quarters(Arch[6,1]) + 4 * max_quarters(Arch[i-2,1]))
    end
  end

  def min_quarters arch
    i, o = *arch
    case
    when i == 0 then 0
    when o == 0 then 0
    when i <= 5 then (o / 2.0).ceil
    else [(i / 5.0).ceil, (o / 2.0).ceil].max
    end
  end
end end
