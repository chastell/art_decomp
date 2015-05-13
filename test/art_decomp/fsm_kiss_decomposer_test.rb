require_relative '../test_helper'
require_relative '../../lib/art_decomp/fsm_kiss_decomposer'
require_relative 'circ_kiss_decomposer'

module ArtDecomp
  describe FSMKISSDecomposer do
    include CircKISSDecomposer
    let(:circ_kiss_decomposer) { FSMKISSDecomposer }
  end
end
