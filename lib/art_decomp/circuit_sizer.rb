module ArtDecomp class CircuitSizer
  def self.size archs
    quarters = archs.map { |arch| quarters arch }.reduce 0, :+
    (quarters / 4.0).ceil
  end

  private

  def self.quarters arch
    case
    when arch.i == 0 then 0
    when arch.i <= 5 then (arch.o / 2.0).ceil
    when arch.i == 6 then arch.o
    when arch.i == 7 then arch.o * 2
    when arch.i == 8 then arch.o * 4
    else arch.o * (quarters(Arch[6,1]) + 4 * quarters(Arch[arch.i-2,1]))
    end
  end
end end
