require_relative '../test_helper'
require_relative '../../lib/art_decomp/kiss_decomposer'
require_relative 'circ_kiss_decomposer'

module ArtDecomp
  describe KISSDecomposer do
    include CircKISSDecomposer
    let(:circ_kiss_decomposer) { KISSDecomposer }
  end
end
