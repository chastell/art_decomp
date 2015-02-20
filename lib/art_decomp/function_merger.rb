require 'set'
require_relative 'function'
require_relative 'puts'

module ArtDecomp
  module FunctionMerger
    def self.merge(functions)
      functions.group_by { |fun| fun.ins.to_set }.map do |ins_set, funs|
        outs = funs.map(&:outs).reduce(:+).uniq
        Function.new(ins: Puts.new(ins_set.to_a), outs: outs)
      end
    end
  end
end
