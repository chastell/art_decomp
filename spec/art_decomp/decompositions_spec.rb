require_relative '../spec_helper'

module ArtDecomp describe Decompositions do
  describe '.for' do
    it 'yields subsequent best decompositions' do
      c1   = fake :circuit, min_size: 7
      c11  = fake :circuit, min_size: 9
      c111 = fake :circuit, min_size: 12
      c112 = fake :circuit, min_size: 10
      c12  = fake :circuit, min_size: 8
      c121 = fake :circuit, min_size: 13
      c13  = fake :circuit, min_size: 11
      tree = { c1 => [c11, c12, c13], c11 => [c111, c112], c12 => [c121] }
      tree.default = []
      decomposer = fake :circuit_decomposer, as: :class
      stub(decomposer).decompose(c1)   { [c11, c12, c13] }
      stub(decomposer).decompose(c11)  { [c111, c112]    }
      stub(decomposer).decompose(c111) { []              }
      stub(decomposer).decompose(c112) { []              }
      stub(decomposer).decompose(c12)  { [c121]          }
      stub(decomposer).decompose(c121) { []              }
      stub(decomposer).decompose(c13)  { []              }
      decs = Decompositions.for c1, decomposer: decomposer
      decs.must_be_kind_of Enumerator
      decs.to_a.must_equal [c1, c12, c11, c112, c13, c111, c121]
    end
  end
end end
