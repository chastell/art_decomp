require_relative '../spec_helper'

module ArtDecomp describe Wire do
  describe '#inspect' do
    it 'returns self-initialising representation' do
      Wire['src', 'dst'].inspect.must_equal 'ArtDecomp::Wire[src, dst]'
    end
  end
end end
