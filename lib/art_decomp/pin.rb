require 'anima'

module ArtDecomp
  class Pin
    include Anima.new(:object, :puts, :put)

    def self.[](object, puts, put)
      new(object: object, puts: puts, put: put)
    end

    def binwidth
      put.binwidth
    end

    def offset
      puts[0...puts.index(put)].binwidth
    end
  end
end
