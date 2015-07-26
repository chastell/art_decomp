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
      "#{self.class}.new(ins: #{ins.inspect}, outs: #{outs.inspect})"
    end

    def size
      ins.first.size
    end

    def to_s
      FunctionPresenter.new(self).simple
    end
  end
end
