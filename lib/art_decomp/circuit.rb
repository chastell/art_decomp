require 'equalizer'
require 'forwardable'
require_relative 'circuit_sizer'
require_relative 'function'
require_relative 'puts_set'
require_relative 'wires'

module ArtDecomp
  class Circuit
    extend Forwardable

    include Equalizer.new(:functions, :puts_set, :recoders, :wires)

    attr_reader :functions, :puts_set, :recoders, :wires

    def self.from_fsm(puts_set)
      fun = Function.new(PutsSet.new(is: puts_set.is + puts_set.qs,
                                     os: puts_set.os + puts_set.ps))
      new(functions: [fun], puts_set: puts_set).tap { |circ| circ.wire_to fun }
    end

    def initialize(functions: [], puts_set: PutsSet.new, recoders: [],
                   wires: Wires.new)
      @functions = functions
      @puts_set  = puts_set
      @recoders  = recoders
      @wires     = wires
    end

    def add_wires(wires)
      @wires += wires
    end

    def adm_size(circuit_sizer: CircuitSizer.new(self))
      @adm_size ||= circuit_sizer.adm_size
    end

    delegate %i(binwidths is os ps qs) => :puts_set

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
      array = (0...puts_set.is.size).map { |n| [[self, :is, n], [fun, :is, n]] }
      Wires.from_array(array)
    end

    def os_wires(fun)
      array = (0...puts_set.os.size).map { |n| [[fun, :os, n], [self, :os, n]] }
      Wires.from_array(array)
    end

    def ps_wires(fun)
      Wires.from_array([[[fun, :os, puts_set.os.size], [self, :ps, 0]]])
    end

    def qs_wires(fun)
      Wires.from_array([[[self, :qs, 0], [fun, :is, puts_set.is.size]]])
    end
  end
end
