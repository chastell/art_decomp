require 'erb'
require_relative 'circuit_presenter'

module ArtDecomp
  class FSMPresenter < CircuitPresenter
    def vhdl(name:)
      super
      template = File.read('lib/art_decomp/fsm_presenter.vhdl.erb')
      ERB.new(template, nil, '%').result(binding)
    end
  end
end
