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
        WirePresenter.new(wire, circuit_presenter: circuit_presenter).wirings
      end.each(&block)
    end

    attr_reader :circuit_presenter
    private     :circuit_presenter
  end
end
