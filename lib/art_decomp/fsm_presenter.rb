require 'erb'
require_relative 'circuit_presenter'
require_relative 'puts'

module ArtDecomp
  class FSMPresenter < CircuitPresenter
    TEMPLATE_PATH = 'lib/art_decomp/fsm_presenter.vhdl.erb'

    private

    def state_binwidth
      state_wires = wires.select do |wire|
        wire.source.object == :circuit and wire.source.group == :states
      end
      state_wires.map { |wire| wire.source.binwidth }.reduce(0, :+)
    end
  end
end
