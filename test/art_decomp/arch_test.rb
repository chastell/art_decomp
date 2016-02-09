# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'

module ArtDecomp
  describe Arch do
    describe '#<=>' do
      it 'makes Archs sortable' do
        unsorted = [Arch[3, 3], Arch[2, 4], Arch[4, 3], Arch[2, 3]]
        sorted   = [Arch[2, 3], Arch[2, 4], Arch[3, 3], Arch[4, 3]]
        _(unsorted.sort).must_equal sorted
      end
    end
  end
end
