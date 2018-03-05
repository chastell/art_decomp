require 'anima'
require_relative 'arch'

module ArtDecomp
  class Function
    class << self
      def [](ins, outs)
        new(ins: ins, outs: outs)
      end
    end

    include Anima.new(:ins, :outs)

    def arch
      Arch[ins.binwidth, outs.binwidth]
    end

    def size
      ins.first.size
    end
  end
end
