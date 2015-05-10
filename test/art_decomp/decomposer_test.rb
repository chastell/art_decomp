require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/circuit_decomposer'
require_relative '../../lib/art_decomp/decomposer'

module ArtDecomp
  describe Decomposer do
    describe '.decompositions' do
      it 'yields subsequent best decompositions' do
        c1   = fake(Circuit, adm_size: 7)
        c11  = fake(Circuit, adm_size: 9)
        c111 = fake(Circuit, adm_size: 12)
        c112 = fake(Circuit, adm_size: 10)
        c12  = fake(Circuit, adm_size: 8)
        c121 = fake(Circuit, adm_size: 13)
        c13  = fake(Circuit, adm_size: 11)
        cd   = fake(CircuitDecomposer, as: :class)
        stub(cd).decompose(c1)   { [c11, c12, c13] }
        stub(cd).decompose(c11)  { [c111, c112]    }
        stub(cd).decompose(c111) { []              }
        stub(cd).decompose(c112) { []              }
        stub(cd).decompose(c12)  { [c121]          }
        stub(cd).decompose(c121) { []              }
        stub(cd).decompose(c13)  { []              }
        decs = Decomposer.decompositions(c1, circuit_decomposer: cd)
        decs.must_be_kind_of Enumerator
        decs.to_a.must_equal [c1, c12, c11, c112, c13, c111, c121]
      end
    end
  end
end
