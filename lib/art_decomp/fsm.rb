require 'anima'
require_relative 'circuit'
require_relative 'function'
require_relative 'wirer'

module ArtDecomp
  class FSM < Circuit
    include Anima.new(:functions, :recoders, :wires)

    def self.from_puts(ins:, outs:)
      function = Function.new(ins: ins, outs: outs)
      wires = Wirer.wires(function, ins: ins, outs: outs)
      new(functions: [function], recoders: [], wires: wires)
    end

    # FIXME: figure out a way to inherit this
    def inspect
      "#{self.class}(#{function_archs})"
    end
  end
end
