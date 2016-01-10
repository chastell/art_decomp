require 'anima'
require 'equalizer'
require_relative 'circuit'
require_relative 'function'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :own, :wires)
    include Equalizer.new(:functions, :own)

    def self.from_function(function)
      in_wires  = function.ins.map  { |put| { put => put } }
      out_wires = function.outs.map { |put| { put => put } }
      wires     = (in_wires + out_wires).reduce({}, :merge)
      new(functions: [function], own: function, wires: wires)
    end
  end
end
