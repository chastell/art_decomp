require_relative '../spec_helper'

module ArtDecomp describe Circuit do
  describe '.from_fsm' do
    it 'creates a Circuit representing the FSM' do
      is = [{ :'0' => [0], :'1' => [1] }]
      os = [{ :'0' => [1], :'1' => [0] }]
      q  = { s1: [0], s2: [1], s3: [2] }
      p  = { s1: [1], s2: [2], s3: [0] }

      ff = MiniTest::Mock.new.expect :new, function = double, [is + [q], os + [p]]

      circuit = Circuit.from_fsm function_factory: ff, is: is, os: os, q: q, p: p

      circuit.functions.must_equal [function]
      ff.verify
    end
  end

  describe '#functions' do
    it 'returns the functions' do
      Circuit.new.functions.must_equal []
      Circuit.new(functions: functions = double).functions.must_equal functions
    end
  end

  describe '#i_widths' do
    it 'returns binary widths of inputs' do
      Circuit.new.i_widths.must_equal []
      Circuit.new(is: [{ a: [0,1], b: [1,2] }, { a: [0], b: [1], c: [2] }])
        .i_widths.must_equal [1, 2]
    end
  end

  describe '#o_widths' do
    it 'returns binary widths of outputs' do
      Circuit.new.o_widths.must_equal []
      Circuit.new(os: [{ a: [0,1], b: [1,2] }, { a: [0], b: [1], c: [2] }])
        .o_widths.must_equal [1, 2]
    end
  end

  describe '#p_widths' do
    it 'returns binary widths of next states' do
      Circuit.new.p_widths.must_equal []
      Circuit.new(ps: [{ a: [0,1], b: [1,2] }, { a: [0], b: [1], c: [2] }])
        .p_widths.must_equal [1, 2]
    end
  end

  describe '#q_widths' do
    it 'returns binary widths of states' do
      Circuit.new.q_widths.must_equal []
      Circuit.new(qs: [{ a: [0,1], b: [1,2] }, { a: [0], b: [1], c: [2] }])
        .q_widths.must_equal [1, 2]
    end
  end

  describe '#recoders' do
    it 'returns the recorders' do
      Circuit.new.recoders.must_equal []
      Circuit.new(recoders: recoders = double).recoders.must_equal recoders
    end
  end

  describe '#wirings' do
    it 'returns the wirings' do
      Circuit.new.wirings.must_equal []
      Circuit.new(wirings: wirings = double).wirings.must_equal wirings
    end
  end
end end
