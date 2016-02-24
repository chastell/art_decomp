# frozen_string_literal: true

require 'delegate'
require 'procto'
require_relative 'function'
require_relative 'required_puts_filter'

module ArtDecomp
  class FunctionSimplifier < DelegateClass(Function)
    include Procto.call

    def call
      outs_seps = outs.map(&:seps).reduce(:|)
      new_ins   = RequiredPutsFilter.call(puts: ins, required_seps: outs_seps)
      Function[new_ins, outs]
    end
  end
end
