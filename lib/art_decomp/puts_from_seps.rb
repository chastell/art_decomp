require 'anima'
require_relative 'put'
require_relative 'puts'

module ArtDecomp
  class PutsFromSeps
    include Anima.new(:allowed, :required, :size)

    def self.puts(allowed:, required:, size:)
      new(allowed: allowed, required: required, size: size).puts
    end

    def puts
      puts = Puts.new
      until (required - puts.seps).empty?
        puts += Puts.new([next_put(required - puts.seps)])
      end
      puts
    end

    private

    def acceptable?(column)
      Seps.from_column(column) | allowed == allowed
    end

    def code_for(column, row, missing)
      forbidden = column.values_at(*missing.seps_of(row)).uniq
      code = :a
      code = code.next while forbidden.include?(code)
      code
    end

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
