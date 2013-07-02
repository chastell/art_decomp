require_relative '../spec_helper'

module ArtDecomp describe CircuitDecomposer do
  describe '.decompose' do
    it 'yields subsequent decomposed circuits' do
      circuit = fake :circuit, largest_function: fun = fake(:function)
      f1, f2  = fake(:function), fake(:function)
      fun_dec = fake :function_decomposer
      mock(fun_dec).decompose(fun) { [f1, f2].to_enum }
      d1, d2  = fake(:circuit), fake(:circuit)
      solder  = fake :circuit_solder
      mock(solder).replace(circuit, fun, f1) { d1 }
      mock(solder).replace(circuit, fun, f2) { d2 }
      decs = CircuitDecomposer.decompose circuit, decomposer: fun_dec,
        solder: solder
      decs.to_a.must_equal [d1, d2]
    end
  end
end end
