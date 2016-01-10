require 'anima'
require 'equalizer'
require_relative 'circuit'
require_relative 'function'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :own, :recoders, :wires)
    include Equalizer.new(:functions, :own, :recoders)

    def self.from_function(function)
      in_wires  = function.ins.map  { |put| { put => put } }
      out_wires = function.outs.map { |put| { put => put } }
      wires     = (in_wires + out_wires).reduce({}, :merge)
      new(functions: [function], own: function, recoders: [], wires: wires)
    end
  end
end
