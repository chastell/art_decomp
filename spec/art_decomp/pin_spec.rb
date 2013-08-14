require_relative '../spec_helper'

module ArtDecomp describe Pin do
  describe '#inspect' do
    it 'returns self-initialising representation' do
      Pin['object', 'group', 'index'].inspect
        .must_equal 'ArtDecomp::Pin[object, group, index]'
    end
  end
end end
