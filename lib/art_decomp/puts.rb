require 'anima'
require 'forwardable'
require_relative 'put'
require_relative 'puts_presenter'
require_relative 'seps'

module ArtDecomp
  class Puts
    extend Forwardable
    include Enumerable
    include Anima.new(:puts)

    def self.from_columns(columns, codes: nil)
      puts = columns.map do |column|
        Put.new(column: column, codes: codes || column.uniq - [:-])
      end
      new(puts)
    end

    def self.from_seps(allowed:, required:, size:)
      PutsFromSeps.puts(allowed: allowed, required: required, size: size)
    end

    def initialize(puts = [])
      @puts = puts
    end

    def &(other)
      self.class.new(puts & other.puts)
    end

    def +(other)
      self.class.new(puts + other.puts)
    end

    def -(other)
      self.class.new(puts - other.puts)
    end

    def [](index_or_range)
      case index_or_range
      when Integer then puts[index_or_range]
      when Range   then self.class.new(puts[index_or_range])
      end
    end

    delegate %i(each empty? index size) => :puts

    def binwidth
      map(&:binwidth).reduce(0, :+)
    end

    def combination(size)
      Enumerator.new do |yielder|
        puts.combination(size).each { |puts| yielder << self.class.new(puts) }
      end
    end

    def inspect
      "#{self.class}.new(#{puts.inspect})"
    end

    def seps
      @seps ||= puts.map(&:seps).reduce(Seps.new, :|)
    end

    def sort_by(&block)
      return to_enum(__method__) unless block_given?
      self.class.new(puts.sort_by(&block))
    end

    def to_s
      PutsPresenter.new(self).simple.join("\n") + "\n"
    end

    def uniq
      self.class.new(puts.uniq)
    end

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

      def acceptable?(column, row, code)
        column.map.with_index.all? do |other, i|
          other == :- or other == code or allowed.separates?(row, i)
        end
      end

      def code_for(column, row, missing)
        forbidden = column.values_at(*missing.seps_of(row)).uniq
        code = :a
        code = code.next while forbidden.include?(code)
        code = :- unless acceptable?(column, row, code)
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
        order.each { |row| column[row] = code_for(column, row, missing) }
        Put[column]
      end
    end
  end
end
