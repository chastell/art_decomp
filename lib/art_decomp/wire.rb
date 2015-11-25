require 'anima'
require_relative 'dst_pin'
require_relative 'src_pin'

module ArtDecomp
  class Wire
    include Anima.new(:source, :destination)

    def self.[](source, destination)
      new(source: source, destination: destination)
    end

    def self.from_arrays(source, destination)
      new(source: SrcPin[*source], destination: DstPin[*destination])
    end
  end
end
