require 'delegate'
require_relative 'function'
require_relative 'required_puts_filter'

module ArtDecomp
  class FunctionSimplifier < SimpleDelegator
    def self.simplify(function)
      new(function).simplified
    end

    def simplified
      outs_seps    = outs.map(&:seps).reduce(:|)
      required_ins = RequiredPutsFilter.required(puts: ins,
                                                 required_seps: outs_seps)
      Function[required_ins, outs]
    end
  end
end
