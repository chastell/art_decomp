# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/fsm_kiss_decomposer'
require_relative 'kiss_decomposer_behaviour'

module ArtDecomp
  describe FSMKISSDecomposer do
    include KISSDecomposerBehaviour
    let(:kiss_decomposer) { FSMKISSDecomposer }
  end
end
