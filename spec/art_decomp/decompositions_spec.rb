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

  describe '#decompositions' do
    it 'yields subsequent best decompositions' do
      c1   = double size: 7
      c11  = double size: 9
      c111 = double size: 12
      c112 = double size: 10
      c12  = double size: 8
      c121 = double size: 13
      c13  = double size: 11
      tree = { c1 => [c11, c12, c13], c11 => [c111, c112], c12 => [c121] }
      tree.default = []
      decomposer = double decomposed: ->(circuit) { tree[circuit].to_enum }
      decs = Decompositions.new(c1).decompositions decomposer: decomposer
      decs.must_be_kind_of Enumerator
      decs.to_a.must_equal [c1, c12, c11, c112, c13, c111, c121]
    end
  end
end end
