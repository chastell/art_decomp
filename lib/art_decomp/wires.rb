require 'equalizer'
require 'forwardable'
require_relative 'wire'

module ArtDecomp
  class Wires
    extend  Forwardable
    include Enumerable
    include Equalizer.new(:wires)

    def self.from_array(array)
      new array.map { |source, target| Wire.from_arrays(source, target) }
    end

    def initialize(wires = [])
      @wires = wires
    end

    def +(other)
      Wires.new(wires + other.wires)
    end

    delegate %i(each) => :wires

    attr_reader :wires
    protected   :wires
  end
end
