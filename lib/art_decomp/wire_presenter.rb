require 'delegate'
require_relative 'pin_presenter'

module ArtDecomp
  class WirePresenter < SimpleDelegator
    def initialize(wire, circuit_presenter:)
      super wire
      @circuit_presenter = circuit_presenter
    end

    def wirings
      src_labels = PinPresenter.new(src).labels
      dst_labels = PinPresenter.new(dst).labels
      src_labels.zip(dst_labels).map do |src_label, dst_label|
        [
          "#{circuit_presenter.wirings_label_for(src.object)}_#{src_label}",
          "#{circuit_presenter.wirings_label_for(dst.object)}_#{dst_label}",
        ]
      end
    end

    attr_reader :circuit_presenter
    private     :circuit_presenter
  end
end
