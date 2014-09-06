require_relative '../spec_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wire'

module ArtDecomp
  describe Circuit do
    describe '.from_fsm' do
      it 'creates a Circuit representing the FSM' do
        is = [Put[:'0' => B[0], :'1' => B[1]]]
        os = [Put[:'0' => B[1], :'1' => B[0]]]
        qs = [Put[s1: B[0], s2: B[1], s3: B[2]]]
        ps = [Put[s1: B[1], s2: B[2], s3: B[0]]]
        circuit  = Circuit.from_fsm Puts.new is: is, os: os, ps: ps, qs: qs
        function = circuit.functions.first
        circuit.functions.must_equal [function]
        function.is.must_equal is + qs
        function.os.must_equal os + ps
        circuit.recoders.must_be :empty?
        circuit.wires.must_equal [
          Wire[Pin[circuit, :is, 0], Pin[function, :is, 0]],
          Wire[Pin[circuit, :qs, 0], Pin[function, :is, 1]],
          Wire[Pin[function, :os, 0], Pin[circuit, :os, 0]],
          Wire[Pin[function, :os, 1], Pin[circuit, :ps, 0]],
        ]
      end
    end

    describe '.new' do
      it 'initialises the Circuit with minimal fuss' do
        [:functions, :recoders, :wires].each do |attr|
          Circuit.new.send(attr).must_equal []
        end
        Circuit.new.puts.must_equal Puts.new
      end
    end

    describe '#==' do
      it 'compares Circuits by value' do
        is, os  = [fake(:put), fake(:put)], [fake(:put), fake(:put)]
        ps, qs  = [fake(:put), fake(:put)], [fake(:put), fake(:put)]
        funs    = [fake(:function), fake(:function)]
        recs    = [fake(:function), fake(:function)]
        wires   = [fake(:wire), fake(:wire)]
        puts    = Puts.new is: is, os: os, ps: ps, qs: qs
        params  = { functions: funs, puts: puts, recoders: recs, wires: wires }
        circuit = Circuit.new params

        assert Circuit.new == Circuit.new # rubocop:disable UselessComparison
        assert circuit == Circuit.new(params)
        refute circuit == Circuit.new(params.merge functions: funs.reverse)
        refute circuit == Circuit.new(params.merge puts: Puts.new)
        refute circuit == Circuit.new(params.merge recoders: recs.reverse)
        refute circuit == Circuit.new(params.merge wires: wires.reverse)
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
        is = [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]]
        qs = [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]]
        circuit = Circuit.new puts: Puts.new(is: is, qs: qs)
        circuit.binwidths(:is).must_equal [1, 2]
        circuit.binwidths(:qs).must_equal [1, 2]
      end
    end

    describe '#functions' do
      it 'gets the functions' do
        Circuit.new(functions: funs = fake(:array)).functions.must_equal funs
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

    describe '#is, #os, #ps, #qs' do
      it 'returns the Circuit’s Put groups' do
        %i(is os ps qs).each do |type|
          ss = [stub(:put)]
          Circuit.new(puts: Puts.new(type => ss)).send(type).must_equal ss
        end
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

    describe '#recoders' do
      it 'gets the Recorders' do
        Circuit.new(recoders: recs = fake(:array)).recoders.must_equal recs
      end
    end

    describe '#wires' do
      it 'gets the wires' do
        Circuit.new(wires: wires = fake(:array)).wires.must_equal wires
      end
    end
  end
end
