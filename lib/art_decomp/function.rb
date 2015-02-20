require 'equalizer'
require_relative 'arch'
require_relative 'puts'

module ArtDecomp
  class Function
    include Equalizer.new(:ins, :outs)

    attr_reader :ins, :outs

    def initialize(ins: Puts.new, outs: Puts.new)
      @ins, @outs = ins, outs
    end

    def arch
      Arch[ins.binwidth, outs.binwidth]
    end

    def inspect
      "#{self.class}(#{arch.inspect})"
    end
  end
end
