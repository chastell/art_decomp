require 'delegate'
require 'forwardable'
require_relative 'wire_presenter'

module ArtDecomp
  class WiresPresenter < SimpleDelegator
    extend Forwardable

    def initialize(wires, circuit:)
      super wires
      @circuit = circuit
    end

    def each(&block)
      flat_map do |wire|
        wirings = WirePresenter.new(wire).wirings
        wirings.map do |(src_obj, src_lab), (dst_obj, dst_lab)|
          [
            "#{wirings_label_for(src_obj)}_#{src_lab}",
            "#{wirings_label_for(dst_obj)}_#{dst_lab}",
          ]
        end
      end.to_h.each(&block)
    end

    attr_reader :circuit
    private     :circuit

    private

    delegate %i(functions recoders) => :circuit

    def wirings_label_for(object)
      case
      when object == circuit          then 'fsm'
      when functions.include?(object) then "f#{functions.index(object)}"
      when recoders.include?(object)  then "r#{recoders.index(object)}"
      end
    end
  end
end
