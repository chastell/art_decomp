require_relative '../spec_helper'

module ArtDecomp describe Decompositions do
  describe '#for' do
    it 'yields subsequent best decompositions' do
      c1   = fake :circuit, adm_size: 7
      c11  = fake :circuit, adm_size: 9
      c111 = fake :circuit, adm_size: 12
      c112 = fake :circuit, adm_size: 10
      c12  = fake :circuit, adm_size: 8
      c121 = fake :circuit, adm_size: 13
      c13  = fake :circuit, adm_size: 11
      tree = { c1 => [c11, c12, c13], c11 => [c111, c112], c12 => [c121] }
      tree.default = []
      circuit_decomposer = fake :circuit_decomposer
      stub(circuit_decomposer).decompose(c1)   { [c11, c12, c13] }
      stub(circuit_decomposer).decompose(c11)  { [c111, c112]    }
      stub(circuit_decomposer).decompose(c111) { []              }
      stub(circuit_decomposer).decompose(c112) { []              }
      stub(circuit_decomposer).decompose(c12)  { [c121]          }
      stub(circuit_decomposer).decompose(c121) { []              }
      stub(circuit_decomposer).decompose(c13)  { []              }
      decs = Decompositions.new.for c1, circuit_decomposer: circuit_decomposer
      decs.must_be_kind_of Enumerator
      decs.to_a.must_equal [c1, c12, c11, c112, c13, c111, c121]
    end
  end
end end
