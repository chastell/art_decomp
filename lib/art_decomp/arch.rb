require 'anima'

module ArtDecomp
  class Arch
    include Anima.new(:i, :o)

    def self.[](i, o)
      new(i: i, o: o)
    end

    def <=>(other)
      (i <=> other.i).nonzero? or o <=> other.o
    end

    def inspect
      "#{self.class}[#{i},#{o}]"
    end
  end
end
