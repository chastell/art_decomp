require 'delegate'
require_relative 'pin_presenter'

module ArtDecomp
  class WiresPresenter < SimpleDelegator
    def initialize(wires, circuit_presenter:)
      super wires
      @circuit_presenter = circuit_presenter
    end

    def each(&block)
      flat_map { |wire| wirings_for(wire) }.each(&block)
    end

    attr_reader :circuit_presenter
    private     :circuit_presenter

    private

    def wirings_for(wire)
      src = PinPresenter.new(wire.src)
      dst = PinPresenter.new(wire.dst)
      src.labels.zip(dst.labels).map do |src_label, dst_label|
        [
          "#{circuit_presenter.wirings_label_for(src.object)}_#{src_label}",
          "#{circuit_presenter.wirings_label_for(dst.object)}_#{dst_label}",
        ]
      end
    end
  end
end
