require 'delegate'
require_relative 'wire_presenter'

module ArtDecomp
  class WiresPresenter < SimpleDelegator
    def initialize(wires, circuit:)
      super wires
      @circuit = circuit
    end

    def wirings
      flat_map { |wire| WirePresenter.new(wire, circuit: circuit).wirings }.to_h
    end

    attr_reader :circuit
    private     :circuit
  end
end
