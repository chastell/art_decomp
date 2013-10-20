require_relative '../spec_helper'

module ArtDecomp describe Circuit do
  describe '.from_fsm' do
    it 'creates a Circuit representing the FSM' do
      is       = [Put[:'0' => B[0], :'1' => B[1]]]
      os       = [Put[:'0' => B[1], :'1' => B[0]]]
      qs       = [Put[s1: B[0], s2: B[1], s3: B[2]]]
      ps       = [Put[s1: B[1], s2: B[2], s3: B[0]]]
      circuit  = Circuit.from_fsm Puts.new is: is, os: os, ps: ps, qs: qs
      function = circuit.functions.first

      circuit.functions.size.must_equal 1
      function.is.must_equal is + qs
      function.os.must_equal os + ps

      circuit.recoders.must_be :empty?

      circuit.wires.must_equal([
        Wire[Pin[circuit, :is, 0], Pin[function, :is, 0]],
        Wire[Pin[circuit, :qs, 0], Pin[function, :is, 1]],
        Wire[Pin[function, :os, 0], Pin[circuit, :os, 0]],
        Wire[Pin[function, :os, 1], Pin[circuit, :ps, 0]],
      ])
    end
  end

  describe '.new' do
    it 'initialises the Circuit with minimal fuss' do
      [:functions, :recoders, :wires].each do |attr|
        Circuit.new.send(attr).must_equal []
      end
      Circuit.new.puts.must_equal Puts.new is: [], os: [], ps: [], qs: []
    end
  end

  describe '#<=>' do
    it 'compares Circuits by value' do
      is, os    = [fake(:put), fake(:put)], [fake(:put), fake(:put)]
      ps, qs    = [fake(:put), fake(:put)], [fake(:put), fake(:put)]
      functions = [fake(:function), fake(:function)]
      recoders  = [fake(:function), fake(:function)]
      wires     = [fake(:wire), fake(:wire)]
      puts      = Puts.new is: is, os: os, ps: ps, qs: qs
      circuit   = Circuit.new functions: functions, puts: puts,
        recoders: recoders, wires: wires

      assert Circuit.new == Circuit.new
      assert circuit == Circuit.new(functions: functions, puts: puts,
        recoders: recoders, wires: wires)
      refute circuit == Circuit.new(functions: functions.reverse, puts: puts,
        recoders: recoders, wires: wires)
      refute circuit == Circuit.new(functions: functions, puts: Puts.new({}),
        recoders: recoders, wires: wires)
      refute circuit == Circuit.new(functions: functions, puts: puts,
        recoders: recoders.reverse, wires: wires)
      refute circuit == Circuit.new(functions: functions, puts: puts,
        recoders: recoders, wires: wires.reverse)
    end
  end

  describe '#adm_size' do
    it 'returns the admissible heuristic size of the Circuit' do
      stub(cs = fake(:circuit_sizer)).adm_size { 7 }
      Circuit.new.adm_size(circuit_sizer: cs).must_equal 7
    end
  end

  describe '#binwidths' do
    it 'returns binary widths of the given Put group' do
      circuit = Circuit.new puts: Puts.new(
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

  describe '#function_archs' do
    it 'returns the Archs of its Functions' do
      f1 = fake :function, arch: Arch[2,1]
      f2 = fake :function, arch: Arch[4,3]
      Circuit.new(functions: [f1, f2]).function_archs
        .must_equal [Arch[2,1], Arch[4,3]]
    end
  end

  describe '#largest_function' do
    it 'returns the largest Function (input- and output-wise)' do
      f23 = fake :function, arch: Arch[2,3]
      f32 = fake :function, arch: Arch[3,2]
      f33 = fake :function, arch: Arch[3,3]
      Circuit.new(functions: [f23, f32, f33]).largest_function.must_equal f33
    end
  end

  describe '#max_size' do
    it 'returns the maximum size of the Circuit' do
      stub(cs = fake(:circuit_sizer)).max_size { 7 }
      Circuit.new.max_size(circuit_sizer: cs).must_equal 7
    end
  end

  describe '#min_size' do
    it 'returns the smallest possible size of the Circuit' do
      stub(cs = fake(:circuit_sizer)).min_size { 7 }
      Circuit.new.min_size(circuit_sizer: cs).must_equal 7
    end
  end

  describe '#puts' do
    it 'gets the puts' do
      Circuit.new(puts: puts = fake(:puts)).puts.must_equal puts
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
