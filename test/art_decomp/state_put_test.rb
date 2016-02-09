# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/state_put'
require_relative 'put_behaviour'

module ArtDecomp
  describe StatePut do
    include PutBehaviour
    let(:put_class) { StatePut }

    describe '#state?' do
      it 'is so, so true' do
        assert StatePut[[]].state?
      end
    end
  end
end
