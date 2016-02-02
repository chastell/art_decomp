require 'delegate'
require_relative 'function'
require_relative 'required_puts_filter'

module ArtDecomp
  class FunctionSimplifier < SimpleDelegator
    def self.call(function)
      new(function).call
    end

    def call
      outs_seps    = outs.map(&:seps).reduce(:|)
      required_ins = RequiredPutsFilter.required(puts: ins,
                                                 required_seps: outs_seps)
      Function[required_ins, outs]
    end
  end
end
