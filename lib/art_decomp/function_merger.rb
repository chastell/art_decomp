require 'set'
require_relative 'function'
require_relative 'puts'

module ArtDecomp
  module FunctionMerger
    def self.merge(functions)
      functions.group_by { |fun| fun.is.to_set }.map do |is, funs|
        os = Puts.new(funs.map(&:os).map(&:puts).flatten.uniq)
        Function.new(is: Puts.new(is.to_a), os: os)
      end
    end
  end
end
