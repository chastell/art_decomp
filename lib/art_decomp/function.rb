require 'anima'
require_relative 'arch'
require_relative 'function_presenter'

module ArtDecomp
  class Function
    include Anima.new(:ins, :outs)

    def arch
      Arch[ins.binwidth, outs.binwidth]
    end

    def inspect
      FunctionPresenter.new(self).simple
    end

    def to_s
      "#{self.class}(#{arch.inspect})"
    end
  end
end
