require 'delegate'
require_relative 'function'
require_relative 'required_puts_filter'

module ArtDecomp
  class FunctionSimplifier < SimpleDelegator
    def self.simplify(function)
      new(function).simplified
    end

    def simplified
      os_seps = os.map(&:seps).reduce(:|)
      required_is = RequiredPutsFilter.required(puts: is,
                                                required_seps: os_seps)
      Function.new(is: required_is, os: os)
    end
  end
end
