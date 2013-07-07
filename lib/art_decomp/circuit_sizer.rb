module ArtDecomp class CircuitSizer
  def adm_size archs
  end

  def max_size archs
    (archs.map { |arch| max_quarters arch }.reduce(0, :+) / 4.0).ceil
  end

  def min_size archs
    (archs.map { |arch| min_quarters arch }.reduce(0, :+) / 4.0).ceil
  end

  private

  def max_quarters arch
    case
    when arch.i == 0 then 0
    when arch.i <= 5 then (arch.o / 2.0).ceil
    when arch.i == 6 then arch.o
    when arch.i == 7 then arch.o * 2
    when arch.i == 8 then arch.o * 4
    else arch.o * (max_quarters(Arch[6,1]) + 4 * max_quarters(Arch[arch.i-2,1]))
    end
  end

  def min_quarters arch
    case
    when arch.i == 0 then 0
    when arch.o == 0 then 0
    when arch.i <= 5 then (arch.o / 2.0).ceil
    else [(arch.i / 5.0).ceil, (arch.o / 2.0).ceil].max
    end
  end
end end
