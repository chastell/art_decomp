require 'erb'
require_relative 'circuit_presenter'

module ArtDecomp
  class FSMPresenter < CircuitPresenter
    TEMPLATE_PATH = 'lib/art_decomp/fsm_presenter.vhdl.erb'
  end
end
