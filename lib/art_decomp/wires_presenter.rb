require 'delegate'
require_relative 'wire_presenter'

module ArtDecomp
  class WiresPresenter < SimpleDelegator
    def initialize(wires, circuit:)
      super wires
      @circuit = circuit
    end

    def each(&block)
      flat_map do |wire|
        WirePresenter.new(wire, circuit: circuit).wirings
      end.to_h.each(&block)
    end

    attr_reader :circuit
    private     :circuit
  end
end
