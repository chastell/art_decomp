require_relative '../spec_helper'

module ArtDecomp describe Put do
  describe '.[]' do
    it 'creates a new Put with the given blanket' do
      Put[a: B[0,1], b: B[1,2]]
        .must_equal Put.new blanket: { a: B[0,1], b: B[1,2] }
    end
  end
end end
