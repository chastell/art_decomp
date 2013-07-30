require_relative '../spec_helper'

module ArtDecomp describe Seps do
  describe '.[]' do
    it 'creates Seps from the given blocks' do
      Seps[B[0,1], B[1,2]].must_equal Seps.new(blocks: [B[0,1], B[1,2]])
      Seps[].must_equal Seps.new
    end
  end
end end
