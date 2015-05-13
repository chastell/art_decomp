require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/pride'
require 'bogus/minitest/spec'
require_relative '../lib/art_decomp'
require_relative '../lib/art_decomp/circuit'
require_relative '../lib/art_decomp/circuit_presenter'
require_relative '../lib/art_decomp/fsm'
require_relative '../lib/art_decomp/fsm_presenter'

Bogus.configure { |config| config.search_modules << ArtDecomp }

Bogus.fakes do
  fake :circ,
       class: -> { [ArtDecomp::Circuit, ArtDecomp::FSM] }
  fake :circ_presenter,
       class: -> { [ArtDecomp::CircuitPresenter, ArtDecomp::FSMPresenter] }
end

class String
  def dedent
    gsub(/^#{scan(/^ +/).min}/, '')
  end
end
