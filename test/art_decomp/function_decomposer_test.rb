require_relative '../test_helper'
require_relative '../../lib/art_decomp/function_decomposer'
require_relative '../../lib/art_decomp/function_decomposer/parallel'
require_relative '../../lib/art_decomp/function_decomposer/serial'

module ArtDecomp
  describe FunctionDecomposer do
    describe '.decompose' do
      it 'returns parallel and serial decompositions' do
        function = fake(:function)
        p1, p2   = fake(:circuit), fake(:circuit)
        s1, s2   = fake(:circuit), fake(:circuit)
        parallel = fake(FunctionDecomposer::Parallel, as: :class)
        serial   = fake(FunctionDecomposer::Serial,   as: :class)
        stub(parallel).decompose(function) { [p1, p2].to_enum }
        stub(serial).decompose(function)   { [s1, s2].to_enum }
        decs = FunctionDecomposer.decompose(function, parallel: parallel,
                                                      serial: serial)
        decs.to_a.must_equal [p1, p2, s1, s2]
      end
    end
  end
end
