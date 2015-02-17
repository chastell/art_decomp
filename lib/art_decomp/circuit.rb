require 'equalizer'
require_relative 'circuit_sizer'
require_relative 'function'
require_relative 'puts'
require_relative 'wires'

module ArtDecomp
  class Circuit
    include Equalizer.new(:functions, :is, :os, :ps, :qs, :recoders, :wires)

    attr_reader :functions, :is, :os, :ps, :qs, :recoders, :wires

    def self.from_fsm(is:, os:, ps:, qs:)
      function = Function.new(is: is + qs, os: os + ps)
      wires = wires_for(function, is: is, os: os)
      new(functions: [function], is: is, os: os, ps: ps, qs: qs, wires: wires)
    end

    def self.is_wires(fun, is:)
      array = (0...is.size).map { |n| [[:circuit, :is, n], [fun, :is, n]] }
      Wires.from_array(array)
    end

    def self.os_wires(fun, os:)
      array = (0...os.size).map { |n| [[fun, :os, n], [:circuit, :os, n]] }
      Wires.from_array(array)
    end

    def self.ps_wires(fun, os:)
      Wires.from_array([[[fun, :os, os.size], [:circuit, :ps, 0]]])
    end

    def self.qs_wires(fun, is:)
      Wires.from_array([[[:circuit, :qs, 0], [fun, :is, is.size]]])
    end

    def self.wires_for(function, is:, os:)
      is_wires(function, is: is) + qs_wires(function, is: is) +
        os_wires(function, os: os) + ps_wires(function, os: os)
    end

    private_class_method :is_wires, :os_wires, :ps_wires, :qs_wires, :wires_for

    def initialize(functions: [], is: Puts.new, os: Puts.new, ps: Puts.new,
                   qs: Puts.new, recoders: [], wires: Wires.new)
      @functions         = functions
      @is, @os, @ps, @qs = is, os, ps, qs
      @recoders          = recoders
      @wires             = wires
    end

    def add_wires(wires)
      @wires += wires
    end

    def adm_size(circuit_sizer: CircuitSizer.new(self))
      @adm_size ||= circuit_sizer.adm_size
    end

    def function_archs
      functions.map(&:arch)
    end

    def inspect
      "#{self.class}(#{function_archs})"
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

    def with_wires(new_wires)
      self.class.new(functions: functions, is: is, os: os, ps: ps, qs: qs,
                     recoders: recoders, wires: new_wires)
    end

    private

    def is_wires(fun)
      array = (0...is.size).map { |n| [[:circuit, :is, n], [fun, :is, n]] }
      Wires.from_array(array)
    end

    def os_wires(fun)
      array = (0...os.size).map { |n| [[fun, :os, n], [:circuit, :os, n]] }
      Wires.from_array(array)
    end

    def ps_wires(fun)
      Wires.from_array([[[fun, :os, os.size], [:circuit, :ps, 0]]])
    end

    def qs_wires(fun)
      Wires.from_array([[[:circuit, :qs, 0], [fun, :is, is.size]]])
    end
  end
end
