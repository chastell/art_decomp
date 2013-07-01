require_relative '../spec_helper'

module ArtDecomp describe CircuitDecomposer do
  describe '.decompose' do
    it 'yields subsequent decomposed circuits' do
      circuit = fake largest_function: fun = fake
      f1, f2  = fake, fake
      fun_dec = fake
      mock(fun_dec).decompose(fun) { [f1, f2].to_enum }
      d1, d2  = fake, fake
      solder  = fake
      mock(solder).replace(circuit, fun, f1) { d1 }
      mock(solder).replace(circuit, fun, f2) { d2 }
      decs = CircuitDecomposer.decompose circuit, decomposer: fun_dec,
        solder: solder
      decs.to_a.must_equal [d1, d2]
    end
  end
end end
