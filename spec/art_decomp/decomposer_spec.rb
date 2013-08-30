require_relative '../spec_helper'

module ArtDecomp describe Decomposer do
  describe '#decompose_circuit' do
    it 'yields subsequent best decompositions' do
      c1   = fake :circuit, adm_size: 7
      c11  = fake :circuit, adm_size: 9
      c111 = fake :circuit, adm_size: 12
      c112 = fake :circuit, adm_size: 10
      c12  = fake :circuit, adm_size: 8
      c121 = fake :circuit, adm_size: 13
      c13  = fake :circuit, adm_size: 11
      cd   = fake :circuit_decomposer
      stub(cd).decompose(c1)   { [c11, c12, c13] }
      stub(cd).decompose(c11)  { [c111, c112]    }
      stub(cd).decompose(c111) { []              }
      stub(cd).decompose(c112) { []              }
      stub(cd).decompose(c12)  { [c121]          }
      stub(cd).decompose(c121) { []              }
      stub(cd).decompose(c13)  { []              }
      decs = Decomposer.new.decompose_circuit c1, circuit_decomposer: cd
      decs.must_be_kind_of Enumerator
      decs.to_a.must_equal [c1, c12, c11, c112, c13, c111, c121]
    end
  end
end end
