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

  describe '#recoders' do
    it 'returns the recorders' do
      Circuit.new.recoders.must_equal []
      Circuit.new(recoders: recoders = double).recoders.must_equal recoders
    end
  end

  describe '#widths' do
    it 'returns binary widths of signals' do
      circuit = Circuit.new(ss: {
        i: [{ a: [0,1], b: [1,2] }, { a: [0], b: [1], c: [2] }],
        q: [{ a: [0,1], b: [1,2] }, { a: [0], b: [1], c: [2] }],
      })
      circuit.widths(:i).must_equal [1, 2]
      circuit.widths(:q).must_equal [1, 2]
    end
  end

  describe '#wirings' do
    it 'returns the wirings' do
      Circuit.new.wirings.must_equal []
      Circuit.new(wirings: wirings = double).wirings.must_equal wirings
    end
  end
end end
