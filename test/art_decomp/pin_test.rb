require_relative '../test_helper'
require_relative '../../lib/art_decomp/pin'

module ArtDecomp
  describe Pin do
    describe '#inspect' do
      it 'returns self-initialising representation' do
        Pin['object', 'group', 'index'].inspect
          .must_equal 'ArtDecomp::Pin[object, group, index]'
      end
    end
  end
end
