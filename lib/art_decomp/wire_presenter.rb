require 'delegate'
require 'forwardable'

module ArtDecomp
  class WirePresenter < SimpleDelegator
    extend Forwardable

    def initialize(wire, circuit:)
      super wire
      @circuit = circuit
    end

    def wirings
      Array.new(dst.object.binwidths(dst.group)[dst.index]) do |n|
        wiring_for(n)
      end
    end

    attr_reader :circuit
    private     :circuit

    private

    delegate %i(functions recoders) => :circuit

    def wiring_for(n)
      src_lab = wirings_label_for(src.object)
      dst_lab = wirings_label_for(dst.object)
      src_bin = src.object.binwidths(src.group)[0...src.index].reduce(0, :+) + n
      dst_bin = dst.object.binwidths(dst.group)[0...dst.index].reduce(0, :+) + n
      [
        "#{src_lab}_#{src.group}(#{src_bin})",
        "#{dst_lab}_#{dst.group}(#{dst_bin})",
      ]
    end

    def wirings_label_for(object)
      case
      when object == circuit          then 'fsm'
      when functions.include?(object) then "f#{functions.index(object)}"
      when recoders.include?(object)  then "r#{recoders.index(object)}"
      end
    end
  end
end
