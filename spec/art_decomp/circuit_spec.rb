require_relative '../spec_helper'

module ArtDecomp describe Circuit do
  describe '.from_fsm' do
    it 'creates a Circuit representing the FSM' do
      is = [{ :'0' => B[0], :'1' => B[1] }]
      os = [{ :'0' => B[1], :'1' => B[0] }]
      qs = [{ s1: B[0], s2: B[1], s3: B[2] }]
      ps = [{ s1: B[1], s2: B[2], s3: B[0] }]

      ff = MiniTest::Mock.new.expect :new, function = double, [is + qs, os + ps]

      circuit = Circuit.from_fsm fun_fact: ff, is: is, os: os, qs: qs, ps: ps

      circuit.functions.must_equal [function]
      circuit.recoders.must_be :empty?
      circuit.wirings.must_equal({
        Pin.new(function, :is, 0) => Pin.new(circuit, :is, 0),
        Pin.new(function, :is, 1) => Pin.new(circuit, :qs, 0),
        Pin.new(circuit, :os, 0) => Pin.new(function, :os, 0),
        Pin.new(circuit, :ps, 0) => Pin.new(function, :os, 1),
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
        is: [{ a: B[0,1], b: B[1,2] }, { a: B[0], b: B[1], c: B[2] }],
        qs: [{ a: B[0,1], b: B[1,2] }, { a: B[0], b: B[1], c: B[2] }],
      })
      circuit.widths(:is).must_equal [1, 2]
      circuit.widths(:qs).must_equal [1, 2]
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
