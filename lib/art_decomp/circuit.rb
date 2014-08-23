require 'equalizer'
require 'forwardable'
require_relative 'circuit_sizer'
require_relative 'function'
require_relative 'pin'
require_relative 'puts'
require_relative 'wire'

module ArtDecomp
  class Circuit
    extend Forwardable

    include Equalizer.new :functions, :puts, :recoders, :wires

    attr_reader :functions, :puts, :recoders, :wires

    def self.from_fsm(puts)
      fun = Function.new Puts.new is: puts.is + puts.qs, os: puts.os + puts.ps
      new(functions: [fun], puts: puts).tap { |circ| circ.wire_to fun }
    end

    def initialize(functions: [], puts: Puts.new, recoders: [], wires: [])
      @functions, @puts, @recoders, @wires = functions, puts, recoders, wires
    end

    def adm_size(circuit_sizer: CircuitSizer.new(self))
      @adm_size ||= circuit_sizer.adm_size
    end

    delegate %i(binwidths is os ps qs) => :puts

    def function_archs
      functions.map(&:arch)
    end

    def largest_function
      functions.max_by(&:arch)
    end

    def max_size(circuit_sizer: CircuitSizer.new(self))
      @max_size ||= circuit_sizer.max_size
    end

    def min_size(circuit_sizer: CircuitSizer.new(self))
      @min_size ||= circuit_sizer.min_size
    end

    def wire_to(function)
      @wires = is_wires(function) + qs_wires(function) +
               os_wires(function) + ps_wires(function)
    end

    private

    def is_wires(fun)
      (0...puts.is.size).map { |n| Wire[Pin[self, :is, n], Pin[fun, :is, n]] }
    end

    def os_wires(fun)
      (0...puts.os.size).map { |n| Wire[Pin[fun, :os, n], Pin[self, :os, n]] }
    end

    def ps_wires(fun)
      [Wire[Pin[fun, :os, puts.os.size], Pin[self, :ps, 0]]]
    end

    def qs_wires(fun)
      [Wire[Pin[self, :qs, 0], Pin[fun, :is, puts.is.size]]]
    end
  end
end
