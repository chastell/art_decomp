require_relative '../spec_helper'
require_relative '../../lib/art_decomp/circuit_decomposer'

module ArtDecomp describe CircuitDecomposer do
  describe '#decompose' do
    it 'yields subsequent decomposed Circuits' do
      circuit = fake :circuit, largest_function: fun = fake(:function)
      c1, c2  = fake(:circuit), fake(:circuit)
      mock(fd = fake(:function_decomposer)).decompose(fun) { [c1, c2] }
      d1, d2  = fake(:circuit), fake(:circuit)
      solder  = fake :circuit_solder
      mock(solder).replace(circuit, fun, c1) { d1 }
      mock(solder).replace(circuit, fun, c2) { d2 }
      decs = CircuitDecomposer.new.decompose circuit, function_decomposer: fd,
                                                      circuit_solder: solder
      decs.to_a.must_equal [d1, d2]
    end
  end
end end
