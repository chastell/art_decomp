require 'anima'
require_relative 'circuit'
require_relative 'function'
require_relative 'wirer'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :own, :recoders, :wires)

    def self.from_function(function)
      wires = Wirer.wires(function, own: function)
      new(functions: [function], own: function, recoders: [], wires: wires)
    end
  end
end
