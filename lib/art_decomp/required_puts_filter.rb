require_relative 'puts'

module ArtDecomp
  class RequiredPutsFilter
    def self.call(puts:, required_seps:)
      puts & new(puts: puts, required_seps: required_seps).call
    end

    def initialize(puts:, required_seps:)
      @required_seps = required_seps
      @sorted_puts   = puts.sort_by { |put| -(put.seps & required_seps).count }
    end

    def call
      remaining = required_seps
      sorted_puts.take_while do |put|
        empty = remaining.empty?
        remaining -= put.seps
        not empty
      end
    end

    private

    attr_reader :required_seps, :sorted_puts
  end
end
