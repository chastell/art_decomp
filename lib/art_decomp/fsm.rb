require 'anima'
require 'equalizer'
require_relative 'circuit'
require_relative 'function'
require_relative 'wirer'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :lines, :own, :recoders, :wires)
    include Equalizer.new(:functions, :own, :recoders, :wires)

    def self.from_function(function)
      in_lines  = function.ins.map  { |put| { put => put } }
      out_lines = function.outs.map { |put| { put => put } }
      lines     = (in_lines + out_lines).reduce({}, :merge)
      wires     = Wirer.wires(function, own: function)
      new(functions: [function], lines: lines, own: function, recoders: [],
          wires: wires)
    end
  end
end
