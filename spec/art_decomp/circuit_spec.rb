require_relative '../spec_helper'

module ArtDecomp describe Circuit do
  describe '.from_fsm' do
    it 'creates a Circuit representing the FSM' do
      is = [Put[:'0' => B[0], :'1' => B[1]]]
      os = [Put[:'0' => B[1], :'1' => B[0]]]
      qs = [Put[s1: B[0], s2: B[1], s3: B[2]]]
      ps = [Put[s1: B[1], s2: B[2], s3: B[0]]]

      circuit = Circuit.from_fsm is: is, os: os, ps: ps, qs: qs

      circuit.functions.size.must_equal 1
      circuit.functions.first.is.must_equal is + qs
      circuit.functions.first.os.must_equal os + ps

      circuit.recoders.must_be :empty?

      function = circuit.functions[0]
      circuit.wires.must_equal([
        Wire.new(circuit.is[0], function.is[0]),
        Wire.new(circuit.qs[0], function.is[1]),
        Wire.new(function.os[0], circuit.os[0]),
        Wire.new(function.os[1], circuit.ps[0]),
      ])
    end
  end

  describe '#functions, #functions=' do
    it 'gets/sets the functions' do
      Circuit.new.functions.must_equal []
      Circuit.new(functions: funs = double).functions.must_equal funs
      Circuit.new.tap { |c| c.functions = funs }.functions.must_equal funs
    end
  end

  describe '#is, #os, #ps, @qs' do
    it 'gets the puts' do
      circ = Circuit.new
      [circ.is, circ.os, circ.ps, circ.qs].must_equal [[], [], [], []]
      circ = Circuit.new is: is = double, os: os = double, ps: ps = double, qs: qs = double
      [circ.is, circ.os, circ.ps, circ.qs].must_equal [is, os, ps, qs]
    end
  end

  describe '#is, #os, #ps, @qs' do
    it 'gets the puts' do
      [:is, :os, :ps, :qs].each do |ss|
        Circuit.new.send(ss).must_equal []
        Circuit.new(ss => puts = double).send(ss).must_equal puts
      end
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
      circuit = Circuit.new(
        is: [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]],
        qs: [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]],
      )
      circuit.widths(:is).must_equal [1, 2]
      circuit.widths(:qs).must_equal [1, 2]
    end
  end

  describe '#wires, #wires=' do
    it 'gets/sets the wires' do
      Circuit.new.wires.must_equal []
      Circuit.new(wires: wires = double).wires.must_equal wires
      Circuit.new.tap { |c| c.wires = wires }.wires.must_equal wires
    end
  end
end end
