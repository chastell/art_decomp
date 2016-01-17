require 'anima'
require_relative 'arch'

module ArtDecomp
  class Function
    include Anima.new(:ins, :outs)

    def self.[](ins, outs)
      new(ins: ins, outs: outs)
    end

    def arch
      Arch[ins.binwidth, outs.binwidth]
    end

    def size
      ins.first.size
    end
  end
end
