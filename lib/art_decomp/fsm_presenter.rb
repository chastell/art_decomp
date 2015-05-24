require 'erb'
require_relative 'circuit_presenter'

module ArtDecomp
  class FSMPresenter < CircuitPresenter
    TEMPLATE_PATH = 'lib/art_decomp/fsm_presenter.vhdl.erb'

    private

    def state_binwidth
      states.binwidth
    end
  end
end
