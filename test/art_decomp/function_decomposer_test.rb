require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_decomposer'
require_relative '../../lib/art_decomp/function_decomposer/parallel'
require_relative '../../lib/art_decomp/function_decomposer/serial'

module ArtDecomp
  describe FunctionDecomposer do
    describe '.decompose' do
      it 'returns parallel and serial decompositions' do
        function   = fake(Function)
        par_decd_a = fake(Circuit)
        par_decd_b = fake(Circuit)
        ser_decd_a = fake(Circuit)
        ser_decd_b = fake(Circuit)
        parallel   = fake(FunctionDecomposer::Parallel, as: :class)
        serial     = fake(FunctionDecomposer::Serial,   as: :class)
        stub(parallel).decompose(function) { [par_decd_a, par_decd_b].to_enum }
        stub(serial).decompose(function)   { [ser_decd_a, ser_decd_b].to_enum }
        decs = FunctionDecomposer.decompose(function, parallel: parallel,
                                                      serial: serial)
        _(decs.to_a).must_equal [par_decd_a, par_decd_b, ser_decd_a, ser_decd_b]
      end
    end
  end
end
