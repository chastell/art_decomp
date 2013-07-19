require_relative '../spec_helper'

module ArtDecomp describe FunctionDecomposer do
  describe '#decompose' do
    it 'returns parallel and serial decompositions' do
      function = fake :function
      p1, p2   = fake(:circuit), fake(:circuit)
      s1, s2   = fake(:circuit), fake(:circuit)
      pfc      = fake :parallel_function_decomposer
      sfc      = fake :serial_function_decomposer
      stub(pfc).decompose(function) { [p1, p2].to_enum }
      stub(sfc).decompose(function) { [s1, s2].to_enum }
      decs = FunctionDecomposer.new.decompose function,
        parallel_function_decomposer: pfc, serial_function_decomposer: sfc
      decs.to_a.must_equal [p1, p2, s1, s2]
    end
  end
end end
