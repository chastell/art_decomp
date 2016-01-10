module ArtDecomp
  class Wires
    def self.from_function(function)
      in_wires  = function.ins.map  { |put| { put => put } }
      out_wires = function.outs.map { |put| { put => put } }
      (in_wires + out_wires).reduce({}, :merge)
    end

    def initialize(wires)
      @wires = wires
    end

    def ==(other)
      wires.keys == other.wires.keys and wires.values == other.wires.values
    end

    protected

    attr_reader :wires
  end
end
