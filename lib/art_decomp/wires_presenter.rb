require 'delegate'
require_relative 'wire_presenter'

module ArtDecomp
  class WiresPresenter < SimpleDelegator
    def initialize(wires, circuit_presenter:)
      super wires
      @circuit_presenter = circuit_presenter
    end

    def each(&block)
      flat_map do |wire|
        WirePresenter.new(wire).labels.map do |src_label, dst_label|
          src_obj_label = circuit_presenter.wirings_label_for(wire.src.object)
          dst_obj_label = circuit_presenter.wirings_label_for(wire.dst.object)
          ["#{src_obj_label}_#{src_label}", "#{dst_obj_label}_#{dst_label}"]
        end
      end.each(&block)
    end

    attr_reader :circuit_presenter
    private     :circuit_presenter
  end
end
