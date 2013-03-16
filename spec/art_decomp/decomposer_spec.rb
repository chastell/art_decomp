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
end end
