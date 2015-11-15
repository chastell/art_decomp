require 'anima'
require_relative 'arch'

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
  end
end
