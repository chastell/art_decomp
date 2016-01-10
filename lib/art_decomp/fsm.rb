require 'anima'
require 'equalizer'
require_relative 'circuit'
require_relative 'function'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :lines, :own, :recoders)
    include Equalizer.new(:functions, :own, :recoders)

    def self.from_function(function)
      in_lines  = function.ins.map  { |put| { put => put } }
      out_lines = function.outs.map { |put| { put => put } }
      lines     = (in_lines + out_lines).reduce({}, :merge)
      new(functions: [function], lines: lines, own: function, recoders: [])
    end
  end
end
