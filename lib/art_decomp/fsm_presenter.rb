require 'erb'
require_relative 'circuit_presenter'
require_relative 'puts'

module ArtDecomp
  class FSMPresenter < CircuitPresenter
    TEMPLATE_PATH = 'lib/art_decomp/fsm_presenter.vhdl.erb'

    private

    def ins_binwidth
      Puts.new(ins.reject(&:state?)).binwidth
    end

    def outs_binwidth
      Puts.new(outs.reject(&:state?)).binwidth
    end

    def state_binwidth
      states.binwidth
    end
  end
end
