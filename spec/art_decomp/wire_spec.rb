require_relative '../spec_helper'
require_relative '../../lib/art_decomp/wire'

module ArtDecomp describe Wire do
  describe '#inspect' do
    it 'returns self-initialising representation' do
      Wire['src', 'dst'].inspect.must_equal 'ArtDecomp::Wire[src, dst]'
    end
  end
end end
