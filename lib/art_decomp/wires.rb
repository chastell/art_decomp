require 'equalizer'
require 'forwardable'
require_relative 'pin'
require_relative 'wire'

module ArtDecomp
  class Wires
    extend  Forwardable
    include Equalizer.new(:wires)

    def self.from_array(array)
      new array.map { |source, target| Wire[Pin[*source], Pin[*target]] }
    end

    def initialize(wires = [])
      @wires = wires
    end

    def +(other)
      Wires.new(wires + other.wires)
    end

    delegate %i(flat_map replace) => :wires

    attr_reader :wires
    protected   :wires
  end
end
