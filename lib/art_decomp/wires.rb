require 'equalizer'

module ArtDecomp
  class Wires
    include Equalizer.new(:wires)

    def self.from_hash(hash)
      new hash.map { |source, target| Wire[Pin[*source], Pin[*target]] }
    end

    def initialize(wires)
      @wires = wires
    end

    attr_reader :wires
    private     :wires
  end
end
