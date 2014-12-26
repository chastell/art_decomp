require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Circuit do
    describe '.from_fsm' do
      it 'creates a Circuit representing the FSM' do
        is = Puts.new([Put[:'0' => B[0], :'1' => B[1]]])
        os = Puts.new([Put[:'0' => B[1], :'1' => B[0]]])
        qs = Puts.new([Put[s1: B[0], s2: B[1], s3: B[2]]])
        ps = Puts.new([Put[s1: B[1], s2: B[2], s3: B[0]]])
        circuit  = Circuit.from_fsm(is: is, os: os, ps: ps, qs: qs)
        function = circuit.functions.first
        circuit.functions.must_equal [function]
        function.is.must_equal is + qs
        function.os.must_equal os + ps
        circuit.recoders.must_be :empty?
        circuit.wires.must_equal Wires.from_array([
          [[circuit,  :is, 0], [function, :is, 0]],
          [[circuit,  :qs, 0], [function, :is, 1]],
          [[function, :os, 0], [circuit,  :os, 0]],
          [[function, :os, 1], [circuit,  :ps, 0]],
        ])
      end
    end

    describe '.new' do
      it 'initialises the Circuit with minimal fuss' do
        Circuit.new.functions.must_equal []
        Circuit.new.is.must_equal Puts.new
        Circuit.new.os.must_equal Puts.new
        Circuit.new.ps.must_equal Puts.new
        Circuit.new.qs.must_equal Puts.new
        Circuit.new.recoders.must_equal []
        Circuit.new.wires.must_equal Wires.new
      end
    end

    describe '#==' do
      it 'compares Circuits by value' do
        is       = Puts.new([fake(:put), fake(:put)])
        os       = Puts.new([fake(:put), fake(:put)])
        ps       = Puts.new([fake(:put), fake(:put)])
        qs       = Puts.new([fake(:put), fake(:put)])
        funs     = [fake(:function), fake(:function)]
        recs     = [fake(:function), fake(:function)]
        wires    = Wires.new([fake(:wire), fake(:wire)])
        params   = { functions: funs, is: is, os: os, ps: ps, qs: qs,
                     recoders: recs, wires: wires }
        circuit  = Circuit.new(params)

        assert Circuit.new == Circuit.new # rubocop:disable UselessComparison
        assert circuit == Circuit.new(params)
        refute circuit == Circuit.new(params.merge(functions: funs.reverse))
        refute circuit == Circuit.new(params.merge(is: Puts.new))
        refute circuit == Circuit.new(params.merge(os: Puts.new))
        refute circuit == Circuit.new(params.merge(ps: Puts.new))
        refute circuit == Circuit.new(params.merge(qs: Puts.new))
        refute circuit == Circuit.new(params.merge(recoders: recs.reverse))
        refute circuit == Circuit.new(params.merge(wires: Wires.new))
      end
    end

    describe '#add_wires' do
      it 'adds the passed Wires to the Circuit' do
        is       = Puts.new([fake(:put), fake(:put)])
        os       = Puts.new([fake(:put), fake(:put)])
        ps       = Puts.new([fake(:put)])
        qs       = Puts.new([fake(:put)])
        function = Function.new(is: is + qs, os: os + ps)
        circuit  = Circuit.new(functions: [function],
                               is: is, os: os, ps: ps, qs: qs)
        circuit.wire_to function
        circuit.add_wires Wires.from_array([[[circuit, :is, 0],
                                             [circuit, :os, 0]]])
        circuit.wires.must_equal Wires.from_array([
          [[circuit,  :is, 0], [function, :is, 0]],
          [[circuit,  :is, 1], [function, :is, 1]],
          [[circuit,  :qs, 0], [function, :is, 2]],
          [[function, :os, 0], [circuit,  :os, 0]],
          [[function, :os, 1], [circuit,  :os, 1]],
          [[function, :os, 2], [circuit,  :ps, 0]],
          [[circuit,  :is, 0], [circuit,  :os, 0]],
        ])
      end
    end

    describe '#adm_size' do
      it 'returns the admissible heuristic size of the Circuit' do
        stub(cs = fake(:circuit_sizer)).adm_size { 7 }
        Circuit.new.adm_size(circuit_sizer: cs).must_equal 7
      end
    end

    describe '#functions' do
      it 'gets the functions' do
        Circuit.new(functions: funs = fake(:array)).functions.must_equal funs
      end
    end

    describe '#function_archs' do
      it 'returns the Archs of its Functions' do
        f1 = fake(:function, arch: Arch[2,1])
        f2 = fake(:function, arch: Arch[4,3])
        Circuit.new(functions: [f1, f2]).function_archs
          .must_equal [Arch[2,1], Arch[4,3]]
      end
    end

    describe '#inpsect' do
      it 'returns a readable representation' do
        f1 = fake(:function, arch: Arch[2,1])
        f2 = fake(:function, arch: Arch[4,3])
        Circuit.new(functions: [f1, f2]).inspect
          .must_equal 'ArtDecomp::Circuit([ArtDecomp::Arch[2,1], ' \
                      'ArtDecomp::Arch[4,3]])'
      end
    end

    describe '#is, #os, #ps, #qs' do
      it 'returns the Circuit’s Put groups' do
        %i(is os ps qs).each do |type|
          puts = Puts.new([stub(:put)])
          Circuit.new(type => puts).send(type).must_equal puts
        end
      end
    end

    describe '#largest_function' do
      it 'returns the largest Function (input- and output-wise)' do
        f23 = fake(:function, arch: Arch[2,3])
        f32 = fake(:function, arch: Arch[3,2])
        f33 = fake(:function, arch: Arch[3,3])
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

    describe '#recoders' do
      it 'gets the Recorders' do
        Circuit.new(recoders: recs = fake(:array)).recoders.must_equal recs
      end
    end

    describe '#wire_to' do
      it 'wires the Circuit to the given Function' do
        is = Puts.new([fake(:put), fake(:put)])
        os = Puts.new([fake(:put), fake(:put)])
        ps = Puts.new([fake(:put)])
        qs = Puts.new([fake(:put)])
        function = Function.new(is: is + qs, os: os + ps)
        circuit  = Circuit.new(functions: [function],
                               is: is, os: os, ps: ps, qs: qs)
        circuit.wire_to function
        circuit.wires.must_equal Wires.from_array([
          [[circuit,  :is, 0], [function, :is, 0]],
          [[circuit,  :is, 1], [function, :is, 1]],
          [[circuit,  :qs, 0], [function, :is, 2]],
          [[function, :os, 0], [circuit,  :os, 0]],
          [[function, :os, 1], [circuit,  :os, 1]],
          [[function, :os, 2], [circuit,  :ps, 0]],
        ])
      end
    end

    describe '#wires' do
      it 'gets the wires' do
        Circuit.new(wires: wires = fake(:array)).wires.must_equal wires
      end
    end
  end
end
