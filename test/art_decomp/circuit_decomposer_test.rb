require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/circuit_decomposer'
require_relative '../../lib/art_decomp/circuit_solder'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_decomposer'

module ArtDecomp
  describe CircuitDecomposer do
    describe '.decompose' do
      it 'yields subsequent decomposed Circuits' do
        circuit = fake(Circuit, largest_function: fun = fake(Function))
        c1, c2  = fake(Circuit), fake(Circuit)
        fd      = fake(FunctionDecomposer, as: :class)
        mock(fd).decompose(fun) { [c1, c2] }
        d1, d2  = fake(Circuit), fake(Circuit)
        solder  = fake(CircuitSolder)
        mock(solder).replace(circuit, fun, c1) { d1 }
        mock(solder).replace(circuit, fun, c2) { d2 }
        decs = CircuitDecomposer.decompose(circuit, function_decomposer: fd,
                                                    circuit_solder: solder)
        decs.to_a.must_equal [d1, d2]
      end
    end
  end
end
