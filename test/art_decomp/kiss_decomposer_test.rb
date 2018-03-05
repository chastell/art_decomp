require_relative '../test_helper'
require_relative '../../lib/art_decomp/kiss_decomposer'
require_relative 'kiss_decomposer_behaviour'

module ArtDecomp
  describe KISSDecomposer do
    include KISSDecomposerBehaviour
    let(:kiss_decomposer) { KISSDecomposer }
  end
end
