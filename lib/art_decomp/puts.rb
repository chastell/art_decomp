# frozen_string_literal: true

require 'anima'
require 'forwardable'
require_relative 'put'
require_relative 'seps'

module ArtDecomp
  class Puts
    extend Forwardable
    include Enumerable
    include Anima.new(:puts)

    def self.[](*columns)
      new(columns.map(&Put.method(:[])))
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

    delegate %i[each empty? size] => :puts

    def binwidth
      @binwidth ||= map(&:binwidth).reduce(0, :+)
    end

    def combination(size)
      Enumerator.new do |yielder|
        puts.combination(size).each { |puts| yielder << self.class.new(puts) }
      end
    end

    alias eql? ==

    def include?(target)
      puts.any? { |put| put.eql?(target) }
    end

    def index(target)
      puts.index { |put| put.eql?(target) }
    end

    def hash
      puts.map(&:column).hash ^ puts.map(&:codes).hash
    end

    def seps
      @seps ||= puts.map(&:seps).reduce(Seps.new, :|)
    end

    def sort
      self.class.new(puts.sort)
    end

    def sort_by
      return to_enum(__method__) unless block_given?
      self.class.new(super)
    end

    def take_while
      return to_enum(__method__) unless block_given?
      self.class.new(super)
    end

    def uniq
      self.class.new(puts.uniq { |put| [put.codes, put.column] })
    end
  end
end
