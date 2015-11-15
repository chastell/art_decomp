require 'anima'
require_relative 'pin'

module ArtDecomp
  class Wire
    include Anima.new(:source, :destination)

    def self.[](source, destination)
      new(source: source, destination: destination)
    end

    def self.from_arrays(source, destination)
      new(source: Pin[*source], destination: Pin[*destination])
    end
  end
end
