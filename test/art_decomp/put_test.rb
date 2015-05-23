require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative 'put_behaviour'

module ArtDecomp
  describe Put do
    include PutBehaviour
    let(:put_class) { Put }
  end
end
