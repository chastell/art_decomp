require_relative '../spec_helper'

module ArtDecomp describe FunctionDecomposer do
  describe '#decompose' do
    it 'returns parallel and serial decompositions' do
      function = fake :function
      p1, p2   = fake(:circuit), fake(:circuit)
      s1, s2   = fake(:circuit), fake(:circuit)
      parallel = fake FunctionDecomposer::Parallel, as: :class
      serial   = fake FunctionDecomposer::Serial
      stub(parallel).decompose(function) { [p1, p2].to_enum }
      stub(serial).decompose(function)   { [s1, s2].to_enum }
      decs = FunctionDecomposer.new.decompose function, parallel: parallel,
        serial: serial
      decs.to_a.must_equal [p1, p2, s1, s2]
    end
  end
end end
