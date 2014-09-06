require 'set'
require_relative 'function'
require_relative 'puts'

module ArtDecomp
  module FunctionMerger
    def self.merge(functions)
      functions.group_by { |fun| fun.is.to_set }.map do |is, funs|
        Function.new(Puts.new(is: is.to_a, os: funs.flat_map(&:os).uniq))
      end
    end
  end
end
