# frozen_string_literal: true

require 'anima'
require_relative 'puts'

module ArtDecomp
  class RequiredPutsFilter
    include Anima.new(:puts, :required_seps)

    def self.call(puts:, required_seps:)
      puts & new(puts: puts, required_seps: required_seps).call
    end

    def call
      remaining = required_seps
      puts_by_relevant_count.take_while do |put|
        empty = remaining.empty?
        remaining -= put.seps
        not empty
      end
    end

    private

    def puts_by_relevant_count
      puts.sort_by { |put| -(put.seps & required_seps).count }
    end
  end
end
