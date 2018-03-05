require 'set'
require_relative 'function'
require_relative 'puts'

module ArtDecomp
  module FunctionMerger
    module_function

    def merge(functions)
      functions.group_by { |fun| fun.ins.uniq.sort }.map do |ins, funs|
        outs = funs.map(&:outs).reduce(:+).uniq
        Function[ins, outs]
      end
    end
  end
end
