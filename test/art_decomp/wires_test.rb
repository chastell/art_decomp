require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/wire'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Wires do
    let(:fun_a) { fake(Function) }
    let(:fun_b) { fake(Function) }
    let(:wires) do
      Wires.new([
        Wire.from_arrays([fun_a, :outs, 0, 1, 0], [fun_b, :ins, 1, 1, 1]),
        Wire.from_arrays([fun_a, :outs, 1, 1, 1], [fun_b, :ins, 0, 1, 0]),
      ])
    end

    describe '.from_array' do
      it 'constructs the Wires from a minimal Array' do
        fa = Wires.from_array([[[fun_a, :outs, 0, 1, 0],
                                [fun_b, :ins, 1, 1, 1]],
                               [[fun_a, :outs, 1, 1, 1],
                                [fun_b, :ins, 0, 1, 0]]])
        fa.must_equal wires
      end
    end

    describe '.new' do
      it 'defaults to empty Wires' do
        Wires.new.must_equal Wires.new([])
      end
    end

    describe '#+' do
      it 'sums the two Wires objects' do
        a = Wires.from_array([[[fun_a, :outs, 0, 1, 0],
                               [fun_b, :ins,  1, 1, 1]]])
        b = Wires.from_array([[[fun_a, :outs, 1, 1, 1],
                               [fun_b, :ins,  0, 1, 0]]])
        (a + b).must_equal wires
      end
    end

    describe '#==' do
      it 'compares two Wires with regard to contents' do
        wires.must_equal Wires.new([
          Wire.from_arrays([fun_a, :outs, 0, 1, 0], [fun_b, :ins, 1, 1, 1]),
          Wire.from_arrays([fun_a, :outs, 1, 1, 1], [fun_b, :ins, 0, 1, 0]),
        ])
        wires.wont_equal Wires.new([
          Wire.from_arrays([fun_a, :outs, 0, 1, 0], [fun_b, :ins, 0, 1, 0]),
          Wire.from_arrays([fun_a, :outs, 1, 1, 1], [fun_b, :ins, 1, 1, 1]),
        ])
      end
    end

    describe '#each' do
      it 'allows iterating over the contents' do
        coll = []
        wires.each { |wire| coll << wire }
        coll.flat_map(&:destination).map(&:index).must_equal [1, 0]
      end
    end
  end
end
