require_relative '../spec_helper'

module ArtDecomp describe Decompositions do
  describe '.for' do
    it 'yields subsequent best decompositions' do
      c1   = fake :circuit, size: 7
      c11  = fake :circuit, size: 9
      c111 = fake :circuit, size: 12
      c112 = fake :circuit, size: 10
      c12  = fake :circuit, size: 8
      c121 = fake :circuit, size: 13
      c13  = fake :circuit, size: 11
      tree = { c1 => [c11, c12, c13], c11 => [c111, c112], c12 => [c121] }
      tree.default = []
      decomposer = fake :circuit_decomposer
      decomposer.define_singleton_method(:decomposed) { |circ| tree[circ] }
      decs = Decompositions.for c1, decomposer: decomposer
      decs.must_be_kind_of Enumerator
      decs.to_a.must_equal [c1, c12, c11, c112, c13, c111, c121]
    end
  end
end end
