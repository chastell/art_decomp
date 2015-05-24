require 'erb'
require_relative 'circuit_presenter'

module ArtDecomp
  class FSMPresenter < CircuitPresenter
    TEMPLATE_PATH = 'lib/art_decomp/fsm_presenter.vhdl.erb'

    private

    def state_binwidth
      pins = wires.map(&:source).select do |pin|
        pin.object == :circuit and pin.group == :states
      end
      pins.map(&:binwidth).reduce(0, :+)
    end
  end
end
