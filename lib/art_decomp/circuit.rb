require 'forwardable'
require_relative 'circuit_sizer'
require_relative 'function'
require_relative 'pin'
require_relative 'puts'
require_relative 'wire'

module ArtDecomp
  class Circuit
    extend Forwardable

    attr_accessor :wires
    attr_reader   :functions, :puts, :recoders

    def self.from_fsm(puts)
      fun = Function.new Puts.new is: puts.is + puts.qs, os: puts.os + puts.ps
      new(functions: [fun], puts: puts, rewire: true)
    end

    def initialize(functions: [], puts: Puts.new, recoders: [], rewire: false,
                   wires: [])
      @functions, @puts, @recoders, @wires = functions, puts, recoders, wires
      rewire! if rewire
    end

    def adm_size(circuit_sizer: CircuitSizer.new(self))
      @adm_size ||= circuit_sizer.adm_size
    end

    delegate %i(binwidths is os ps qs) => :puts

    def eql?(other)
      functions.eql? other.functions and puts.eql? other.puts and
        recoders.eql? other.recoders and wires.eql? other.wires
    end

    alias_method :==, :eql?

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

    private

    def rewire!
      is_size = puts.is.size
      os_size = puts.os.size
      fun  = functions.first
      ins  = (0...is_size).map { |n| Wire[Pin[self, :is, n], Pin[fun, :is, n]] }
      outs = (0...os_size).map { |n| Wire[Pin[fun, :os, n], Pin[self, :os, n]] }
      @wires = ins  + [Wire[Pin[self, :qs, 0], Pin[fun, :is, is_size]]] +
               outs + [Wire[Pin[fun, :os, os_size], Pin[self, :ps, 0]]]
    end
  end
end
