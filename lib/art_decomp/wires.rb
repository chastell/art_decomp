require 'equalizer'
require 'forwardable'

module ArtDecomp
  class Wires
    extend  Forwardable
    include Equalizer.new(:wires)

    def self.from_hash(hash)
      new hash.map { |source, target| Wire[Pin[*source], Pin[*target]] }
    end

    def initialize(wires = [])
      @wires = wires
    end

    delegate %i(flat_map replace) => :wires

    attr_reader :wires
    private     :wires
  end
end
