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

    it 'decomposes the widest function until the circuit fits the width' do
      c7  = double max_width: 7
      c9  = double max_width: 9,  widest_function: c9wf  = double, replace: -> _,_ { c7 }
      c11 = double max_width: 11, widest_function: c11wf = double, replace: -> _,_ { c9 }
      fundec = MiniTest::Mock.new
      fundec.expect :decompose, double, [c11wf, { width: 7 }]
      fundec.expect :decompose, double, [c9wf,  { width: 7 }]
      decomposer = Decomposer.new c11, width: 7
      decomposer.decompose(function_decomposer: fundec).must_equal c7
      fundec.verify
    end
  end
end end
