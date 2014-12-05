require 'delegate'
require 'forwardable'
require_relative 'pin_presenter'

module ArtDecomp
  class WiresPresenter < SimpleDelegator
    extend Forwardable

    def initialize(wires, circuit_presenter:)
      super wires
      @circuit_presenter = circuit_presenter
    end

    def each(&block)
      flat_map do |wire|
        src = PinPresenter.new(wire.src)
        dst = PinPresenter.new(wire.dst)
        src.labels.zip(dst.labels).map do |src_label, dst_label|
          [
            "#{wirings_label_for(src.object)}_#{src_label}",
            "#{wirings_label_for(dst.object)}_#{dst_label}",
          ]
        end
      end.each(&block)
    end

    attr_reader :circuit_presenter
    private     :circuit_presenter

    private

    delegate %i(functions recoders) => :circuit_presenter

    def wirings_label_for(object)
      case
      when object == circuit_presenter.circuit then 'fsm'
      when functions.include?(object) then "f#{functions.index(object)}"
      when recoders.include?(object)  then "r#{recoders.index(object)}"
      end
    end
  end
end
