require_relative '../spec_helper'

module ArtDecomp describe Decomposer do
  describe '.decompositions_for' do
    it 'yields subsequent decompositions' do
      decomposer = double decompositions: [d1 = double, d2 = double].to_enum
      Decomposer.stub :new, decomposer do
        decs = Decomposer.decompositions_for double
        decs.must_be_kind_of Enumerator
        decs.to_a.must_equal [d1, d2]
      end
    end
  end
end end
