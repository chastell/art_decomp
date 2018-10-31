require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/circuit_decomposer'
require_relative '../../lib/art_decomp/circuit_solder'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_decomposer'

module ArtDecomp
  describe CircuitDecomposer do
    describe '.call' do
      it 'yields subsequent decomposed Circuits' do
        largest_function = fake(Function)
        decomposed_a = fake(Circuit)
        decomposed_b = fake(Circuit)
        fd = fake(FunctionDecomposer, as: :class)
        mock(fd).call(largest_function) { [decomposed_a, decomposed_b] }
        composed   = fake(Circuit, largest_function: largest_function)
        replaced_a = fake(Circuit)
        replaced_b = fake(Circuit)
        solder = fake(CircuitSolder, as: :class)
        mock(solder).call(composed: composed, decomposed: decomposed_a,
                          function: largest_function) { replaced_a }
        mock(solder).call(composed: composed, decomposed: decomposed_b,
                          function: largest_function) { replaced_b }
        decs = CircuitDecomposer.call(composed, function_decomposer: fd,
                                                circuit_solder:      solder)
        _(decs.to_a).must_equal [replaced_a, replaced_b]
      end
    end
  end
end
