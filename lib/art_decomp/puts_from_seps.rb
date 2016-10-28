# frozen_string_literal: true

require 'anima'
require 'procto'
require_relative 'put'
require_relative 'puts'

module ArtDecomp
  class PutsFromSeps
    include Anima.new(:allowed, :required, :size)
    include Procto.call

    def call
      puts = Puts.new
      missing = required
      until missing.empty?
        puts += Puts.new([next_put(missing)])
        missing -= puts.seps
      end
      puts
    end

    private

    def acceptable?(column)
      Seps.from_column(column) | allowed == allowed
    end

    # :reek:UtilityFunction
    def code_for(column, row, missing)
      forbidden = column.values_at(*missing.seps_of(row)).uniq
      code = :a
      code = code.next while forbidden.include?(code)
      code
    end

    # :reek:FeatureEnvy
    def next_put(missing)
      missing.nonempty_by_popcount.permutation do |order|
        put = put_for_order(order, missing)
        return put unless (missing & put.seps).empty?
      end
    end

    def put_for_order(order, missing)
      column = Array.new(size, :-)
      order.each do |row|
        column[row] = code_for(column, row, missing)
        column[row] = :- unless acceptable?(column)
      end
      Put[column]
    end
  end
end
