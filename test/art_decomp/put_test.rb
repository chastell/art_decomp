# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative 'put_behaviour'

module ArtDecomp
  describe Put do
    include PutBehaviour
    let(:put_class) { Put }

    describe '#state?' do
      it 'is so very false' do
        refute Put[[]].state?
      end
    end
  end
end
