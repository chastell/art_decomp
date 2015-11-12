require 'anima'
require 'forwardable'
require_relative 'wire'

module ArtDecomp
  class Wires
    extend Forwardable
    include Enumerable
    include Anima.new(:wires)

    def self.from_array(array)
      new(array.map { |source, target| Wire.from_arrays(source, target) })
    end

    def initialize(wires = [])
      @wires = wires
    end

    def +(other)
      self.class.new(wires + other.wires)
    end

    delegate each: :wires
  end
end
