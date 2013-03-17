require_relative '../spec_helper'

module ArtDecomp describe Decomposer do
  describe '.decompose_circuit' do
    it 'decomposes the passed Circuit' do
      decomposer = MiniTest::Mock.new.expect :decompose, decomposed = double
      Decomposer.stub :new, decomposer do
        Decomposer.decompose_circuit(double, width: 7).must_equal decomposed
      end
      decomposer.verify
    end
  end

  describe '#decompose' do
    it 'returns the circuit if its widest function fits width' do
      circuit = double max_width: 7
      Decomposer.new(circuit, width: 7).decompose.must_equal circuit
    end

    it 'tells circuit to replace the widest function with decomposed' do
      circuit = MiniTest::Mock.new
      circuit.expect :max_width, 11
      circuit.expect :widest_function, widest = double
      fundec = MiniTest::Mock.new
      fundec.expect :decompose, result = double, [widest, { width: 7 }]
      circuit.expect :replace, decomposed = double, [widest, result]
      decomposer = Decomposer.new circuit, width: 7
      decomposer.decompose(function_decomposer: fundec).must_equal decomposed
      circuit.verify
      fundec.verify
    end
  end
end end
