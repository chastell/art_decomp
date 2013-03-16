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
  end
end end
