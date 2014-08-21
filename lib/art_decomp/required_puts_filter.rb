class RequiredPutsFilter
  def self.required(puts:, seps:)
    new(puts: puts, seps: seps).required_puts
  end

  def initialize(puts:, seps:)
    @seps        = seps
    @sorted_puts = puts.sort_by { |put| (put.seps & seps).size }.reverse
  end

  def required_puts
    remaining = seps
    sorted_puts.take_while do |put|
      empty = remaining.empty?
      remaining -= put.seps
      not empty
    end
  end

  attr_reader :seps, :sorted_puts
  private     :seps, :sorted_puts
end
