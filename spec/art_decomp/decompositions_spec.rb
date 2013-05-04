require_relative '../spec_helper'

module ArtDecomp describe Decompositions do
  describe '.for' do
    it 'yields subsequent decomposed circuits' do
      decs = double decompositions: [c1 = double, c2 = double].to_enum
      Decompositions.stub :new, decs do
        decs_for = Decompositions.for double
        decs_for.must_be_kind_of Enumerator
        decs_for.to_a.must_equal [c1, c2]
      end
    end
  end
end end
