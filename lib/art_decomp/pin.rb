require 'anima'
require 'forwardable'

module ArtDecomp
  class Pin
    extend Forwardable
    include Anima.new(:object, :puts, :put)

    def self.[](object, puts, put)
      new(object: object, puts: puts, put: put)
    end

    delegate binwidth: :put

    def circuit?
      object == :circuit
    end

    def offset
      puts[0...puts.index(put)].binwidth
    end
  end
end
