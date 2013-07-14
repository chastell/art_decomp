module ArtDecomp class CircuitSizer
  def initialize circuit
    @circuit = circuit
  end

  def adm_size
  end

  def max_size
  end

  def min_size
    (circuit.functions.map(&:arch).map do |arch|
      min_quarters arch
    end.reduce(0, :+) / 4.0).ceil
  end

  attr_reader :circuit
  private     :circuit

  private

  def min_quarters arch
    case
    when arch.i == 0 then 0
    when arch.o == 0 then 0
    when arch.i <= 5 then (arch.o / 2.0).ceil
    else [(arch.i / 5.0).ceil, (arch.o / 2.0).ceil].max
    end
  end
end end
