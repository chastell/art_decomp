# frozen_string_literal: true

require 'anima'

module ArtDecomp
  class Arch
    class << self
      # :reek:UncommunicativeParameterName
      def [](i, o)
        new(i: i, o: o)
      end
    end

    include Anima.new(:i, :o)

    def <=>(other)
      (i <=> other.i).nonzero? or o <=> other.o
    end
  end
end
