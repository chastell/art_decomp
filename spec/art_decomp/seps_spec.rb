require_relative '../spec_helper'

module ArtDecomp describe Seps do
  let(:seps) { Seps[B[0,1], B[1,2]] }

  describe '.[]' do
    it 'creates Seps from the given blocks' do
      seps.must_equal Seps.new(blocks: [B[0,1], B[1,2]])
      Seps[].must_equal Seps.new
    end
  end

  describe '#==' do
    it 'compares two Seps by value' do
      assert seps == seps.dup
      assert seps == Seps[B[1,2], B[0,1]]
      refute seps == Seps[B[0,2], B[1,2]]
    end
  end
end end
