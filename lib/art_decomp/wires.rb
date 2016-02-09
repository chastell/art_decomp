# frozen_string_literal: true

require 'forwardable'

module ArtDecomp
  class Wires
    extend Forwardable
    include Enumerable

    def self.from_function(function)
      in_wires  = function.ins.map  { |put| { put => put } }
      out_wires = function.outs.map { |put| { put => put } }
      new((in_wires + out_wires).reduce({}, :merge))
    end

    def initialize(wires = {})
      @wires = wires
    end

    def +(other)
      self.class.new(wires.merge(other.wires))
    end

    def ==(other)
      wires.keys == other.wires.keys and wires.values == other.wires.values
    end

    delegate %i([] each) => :wires

    def invert
      self.class.new(wires.invert)
    end

    def reject(&block)
      return to_enum(__method__) unless block_given?
      self.class.new(wires.reject(&block))
    end

    protected

    attr_reader :wires
  end
end
