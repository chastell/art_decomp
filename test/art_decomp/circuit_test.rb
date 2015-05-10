require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/circuit_sizer'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Circuit do
    let(:empty) do
      Circuit.new(functions: [], ins: Puts.new, outs: Puts.new,
                  states: Puts.new, next_states: Puts.new, recoders: [],
                  wires: Wires.new)
    end

    describe '.from_puts' do
      it 'creates a Circuit representing the FSM' do
        ins  = Puts.from_columns([%i(0 1)])
        outs = Puts.from_columns([%i(1 0)])
        states      = Puts.from_columns([%i(s1 s2 s3)])
        next_states = Puts.from_columns([%i(s3 s1 s2)])
        circuit  = Circuit.from_puts(ins: ins, outs: outs, states: states,
                                     next_states: next_states)
        function = Function.new(ins: ins + states, outs: outs + next_states)
        circuit.functions.must_equal [function]
        circuit.recoders.must_be :empty?
        circuit.wires.must_equal Wires.from_array([
          [[:circuit, :ins,    0], [function, :ins,         0]],
          [[:circuit, :states, 0], [function, :ins,         1]],
          [[function, :outs,   0], [:circuit, :outs,        0]],
          [[function, :outs,   1], [:circuit, :next_states, 0]],
        ])
      end
    end

    describe '#adm_size' do
      it 'returns the admissible heuristic size of the Circuit' do
        stub(cs = fake(CircuitSizer)).adm_size { 7 }
        empty.adm_size(circuit_sizer: cs).must_equal 7
      end
    end

    describe '#functions' do
      it 'gets the functions' do
        empty.update(functions: funs = fake(Array)).functions.must_equal funs
      end
    end

    describe '#function_archs' do
      it 'returns the Archs of its Functions' do
        f1 = fake(Function, arch: Arch[2,1])
        f2 = fake(Function, arch: Arch[4,3])
        empty.update(functions: [f1, f2]).function_archs
          .must_equal [Arch[2,1], Arch[4,3]]
      end
    end

    describe '#inpsect' do
      it 'returns a readable representation' do
        f1 = fake(Function, arch: Arch[2,1])
        f2 = fake(Function, arch: Arch[4,3])
        empty.update(functions: [f1, f2]).inspect
          .must_equal 'ArtDecomp::Circuit([ArtDecomp::Arch[2,1], ' \
                      'ArtDecomp::Arch[4,3]])'
      end
    end

    describe '#ins, #outs, #states, #next_states' do
      it 'returns the Circuit’s Put groups' do
        %i(ins outs states next_states).each do |type|
          puts = Puts.new([stub(:put)])
          empty.update(type => puts).send(type).must_equal puts
        end
      end
    end

    describe '#largest_function' do
      it 'returns the largest Function (input- and output-wise)' do
        f23 = fake(Function, arch: Arch[2,3])
        f32 = fake(Function, arch: Arch[3,2])
        f33 = fake(Function, arch: Arch[3,3])
        empty.update(functions: [f23, f32, f33]).largest_function.must_equal f33
      end
    end

    describe '#max_size' do
      it 'returns the maximum size of the Circuit' do
        stub(cs = fake(CircuitSizer)).max_size { 7 }
        empty.max_size(circuit_sizer: cs).must_equal 7
      end
    end

    describe '#min_size' do
      it 'returns the smallest possible size of the Circuit' do
        stub(cs = fake(CircuitSizer)).min_size { 7 }
        empty.min_size(circuit_sizer: cs).must_equal 7
      end
    end

    describe '#recoders' do
      it 'gets the Recorders' do
        empty.update(recoders: recs = fake(Array)).recoders.must_equal recs
      end
    end

    describe '#wires' do
      it 'gets the wires' do
        empty.update(wires: wires = fake(Array)).wires.must_equal wires
      end
    end
  end
end
