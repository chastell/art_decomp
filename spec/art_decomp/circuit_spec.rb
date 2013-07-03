require_relative '../spec_helper'

module ArtDecomp describe Circuit do
  describe '.from_fsm' do
    it 'creates a Circuit representing the FSM' do
      is       = [Put[:'0' => B[0], :'1' => B[1]]]
      os       = [Put[:'0' => B[1], :'1' => B[0]]]
      qs       = [Put[s1: B[0], s2: B[1], s3: B[2]]]
      ps       = [Put[s1: B[1], s2: B[2], s3: B[0]]]
      circuit  = Circuit.from_fsm is: is, os: os, ps: ps, qs: qs
      function = circuit.functions.first

      circuit.functions.size.must_equal 1
      function.is.must_equal is + qs
      function.os.must_equal os + ps

      circuit.recoders.must_be :empty?

      circuit.wires.must_equal([
        Wire.new(circuit.is[0], function.is[0]),
        Wire.new(circuit.qs[0], function.is[1]),
        Wire.new(function.os[0], circuit.os[0]),
        Wire.new(function.os[1], circuit.ps[0]),
      ])
    end
  end

  describe '.new' do
    it 'initialises the Circuit with minimal fuss' do
      [:functions, :is, :os, :ps, :qs, :recoders, :wires].each do |attr|
        Circuit.new.send(attr).must_equal []
      end
    end
  end

  describe '#binwidths' do
    it 'returns binary widths of the given Put group' do
      circuit = Circuit.new(
        is: [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]],
        qs: [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]],
      )
      circuit.binwidths(:is).must_equal [1, 2]
      circuit.binwidths(:qs).must_equal [1, 2]
    end
  end

  describe '#functions, #functions=' do
    it 'gets/sets the functions' do
      Circuit.new(functions: funs = fake(:array)).functions.must_equal funs
      Circuit.new.tap { |c| c.functions = funs }.functions.must_equal funs
    end
  end

  describe '#is, #os, #ps, #qs' do
    it 'gets the puts' do
      circ = Circuit.new is: is = fake(:array), os: os = fake(:array),
        ps: ps = fake(:array), qs: qs = fake(:array)
      [circ.is, circ.os, circ.ps, circ.qs].must_equal [is, os, ps, qs]
    end
  end

  describe '#is, #os, #ps, #qs' do
    it 'gets the puts' do
      [:is, :os, :ps, :qs].each do |ss|
        Circuit.new(ss => puts = fake(:array)).send(ss).must_equal puts
      end
    end
  end

  describe '#max_size' do
    it 'returns the maximum size of the Circuit' do
      f1 = fake :function, arch: a1 = Arch[1,2]
      f2 = fake :function, arch: a2 = Arch[3,4]
      stub(cs = fake(:circuit_sizer)).max_size([a1, a2]) { 7 }
      Circuit.new(functions: [f1, f2]).max_size(circuit_sizer: cs).must_equal 7
    end
  end

  describe '#min_size' do
    it 'returns the smallest possible size of the Circuit' do
      f1 = fake :function, arch: a1 = Arch[1,2]
      f2 = fake :function, arch: a2 = Arch[3,4]
      stub(cs = fake(:circuit_sizer)).min_size([a1, a2]) { 7 }
      Circuit.new(functions: [f1, f2]).min_size(circuit_sizer: cs)
        .must_equal 7
    end
  end

  describe '#recoders, #recoders=' do
    it 'gets/sets the Recorders' do
      Circuit.new(recoders: recs = fake(:array)).recoders.must_equal recs
      Circuit.new.tap { |c| c.recoders = recs }.recoders.must_equal recs
    end
  end

  describe '#wires, #wires=' do
    it 'gets/sets the wires' do
      Circuit.new(wires: wires = fake(:array)).wires.must_equal wires
      Circuit.new.tap { |c| c.wires = wires }.wires.must_equal wires
    end
  end
end end
