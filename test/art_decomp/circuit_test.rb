require_relative '../test_helper'
require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/archs_sizer'
require_relative '../../lib/art_decomp/circuit'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Circuit do
    let(:archs_sizer) { fake(ArchsSizer, as: :class) }

    let(:empty) do
      Circuit.new(archs_sizer: archs_sizer, functions: [],
                  own: Function.new(ins: Puts.new, outs: Puts.new),
                  wires: Wires.new({}))
    end

    describe '.from_function' do
      it 'creates a Circuit representing the Function' do
        ins  = Puts.from_columns([%i(0 1)])
        outs = Puts.from_columns([%i(1 0)])
        function = Function.new(ins: ins, outs: outs)
        circuit  = Circuit.from_function(function)
        wires    = Wires.new(ins[0] => ins[0], outs[0] => outs[0])
        _(circuit.functions).must_equal [function]
        _(circuit.own).must_equal function
        _(circuit.wires).must_equal wires
      end
    end

    describe '#adm_size' do
      it 'returns the admissible heuristic size of the Circuit' do
        stub(archs_sizer).adm_size([]) { 7 }
        _(empty.adm_size).must_equal 7
      end
    end

    describe '#functions' do
      it 'gets the functions' do
        functions = fake(Array)
        _(empty.with(functions: functions).functions).must_equal functions
      end
    end

    describe '#largest_function' do
      it 'returns the largest Function (input- and output-wise)' do
        f23 = fake(Function, arch: Arch[2,3])
        f32 = fake(Function, arch: Arch[3,2])
        f33 = fake(Function, arch: Arch[3,3])
        nonempty = empty.with(functions: [f23, f32, f33])
        _(nonempty.largest_function).must_equal f33
      end
    end

    describe '#max_size' do
      it 'returns the maximum size of the Circuit' do
        stub(archs_sizer).max_size([]) { 7 }
        _(empty.max_size).must_equal 7
      end
    end

    describe '#min_size' do
      it 'returns the smallest possible size of the Circuit' do
        stub(archs_sizer).min_size([]) { 7 }
        _(empty.min_size).must_equal 7
      end
    end

    describe '#wires' do
      it 'gets the wires' do
        _(empty.with(wires: wires = fake(Wires)).wires).must_equal wires
      end
    end
  end
end
