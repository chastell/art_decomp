require_relative '../spec_helper'

module ArtDecomp describe CircuitDecomposer do
  describe '.decompose' do
    it 'yields subsequent decomposed circuits' do
      circuit = double largest_function: fun = double
      df1, df2 = double, double
      fun_dec = MiniTest::Mock.new.expect :decompose, [df1, df2].to_enum, [fun]
      solder  = MiniTest::Mock.new
      solder.expect :replace, dec1 = double, [circuit, fun, df1]
      solder.expect :replace, dec2 = double, [circuit, fun, df2]
      decs = CircuitDecomposer.decompose circuit, decomposer: fun_dec,
        solder: solder
      decs.to_a.must_equal [dec1, dec2]
      fun_dec.verify
      solder.verify
    end
  end
end end
