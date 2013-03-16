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
      circuit.recoders.must_be :empty?
      circuit.wirings.must_equal({
        Pin.new(function, :i, 0) => Pin.new(circuit, :i, 0),
        Pin.new(function, :i, 1) => Pin.new(circuit, :q, 0),
        Pin.new(circuit, :o, 0) => Pin.new(function, :o, 0),
        Pin.new(circuit, :p, 0) => Pin.new(function, :o, 1),
      })
      ff.verify
    end
  end

  describe '#functions, #functions=' do
    it 'gets/sets the functions' do
      Circuit.new.functions.must_equal []
      Circuit.new(functions: funs = double).functions.must_equal funs
      Circuit.new.tap { |c| c.functions = funs }.functions.must_equal funs
    end
  end

  describe '#max_width' do
    it 'returns the width of the widest Function' do
      Circuit.new.max_width.must_equal 0
      functions = [double(width: 3), double(width: 4)]
      Circuit.new(functions: functions).max_width.must_equal 4
    end
  end

  describe '#recoders, #recoders=' do
    it 'gets/sets the recorders' do
      Circuit.new.recoders.must_equal []
      Circuit.new(recoders: recs = double).recoders.must_equal recs
      Circuit.new.tap { |c| c.recoders = recs }.recoders.must_equal recs
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

  describe '#wirings, #wirings=' do
    it 'gets/sets the wirings' do
      Circuit.new.wirings.must_equal({})
      Circuit.new(wirings: wirs = double).wirings.must_equal wirs
      Circuit.new.tap { |c| c.wirings = wirs }.wirings.must_equal wirs
    end
  end
end end
