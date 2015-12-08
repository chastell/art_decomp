require_relative '../test_helper'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/wire'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Wires do
    let(:fun_a) do
      KISSParser.function_for <<-end
        01 ba
        10 ab
      end
    end

    let(:fun_b) do
      KISSParser.function_for <<-end
        ba 01
        ab 10
      end
    end

    let(:wires) do
      Wires.new([
        Wire.from_arrays([fun_a, fun_a.outs, fun_a.outs[0]],
                         [fun_b, fun_b.ins,  fun_b.ins[1]]),
        Wire.from_arrays([fun_a, fun_a.outs, fun_a.outs[1]],
                         [fun_b, fun_b.ins,  fun_b.ins[0]]),
      ])
    end

    describe '.from_array' do
      it 'constructs the Wires from a minimal Array' do
        fa = Wires.from_array([
          [[fun_a, fun_a.outs, fun_a.outs[0]],
           [fun_b, fun_b.ins,  fun_b.ins[1]]],
          [[fun_a, fun_a.outs, fun_a.outs[1]],
           [fun_b, fun_b.ins,  fun_b.ins[0]]],
        ])
        _(fa).must_equal wires
      end
    end

    describe '.new' do
      it 'defaults to empty Wires' do
        _(Wires.new).must_equal Wires.new([])
      end
    end

    describe '#+' do
      it 'sums the two Wires objects' do
        a = Wires.from_array([
          [[fun_a, fun_a.outs, fun_a.outs[0]],
           [fun_b, fun_b.ins,  fun_b.ins[1]]]
        ])
        b = Wires.from_array([
          [[fun_a, fun_a.outs, fun_a.outs[1]],
           [fun_b, fun_b.ins,  fun_b.ins[0]]]
        ])
        _(a + b).must_equal wires
      end
    end

    describe '#==' do
      it 'compares two Wires with regard to contents' do
        _(wires).must_equal Wires.new([
          Wire.from_arrays([fun_a, fun_a.outs, fun_a.outs[0]],
                           [fun_b, fun_b.ins,  fun_b.ins[1]]),
          Wire.from_arrays([fun_a, fun_a.outs, fun_a.outs[1]],
                           [fun_b, fun_b.ins,  fun_b.ins[0]]),
        ])
        _(wires).wont_equal Wires.new([
          Wire.from_arrays([fun_a, fun_a.outs, fun_a.outs[0]],
                           [fun_b, fun_b.ins,  fun_b.ins[0]]),
          Wire.from_arrays([fun_a, fun_a.outs, fun_a.outs[1]],
                           [fun_b, fun_b.ins,  fun_b.ins[1]]),
        ])
      end
    end

    describe '#each' do
      it 'allows iterating over the contents' do
        coll = []
        wires.each { |wire| coll << wire }
        _(coll.flat_map(&:destination).map(&:group)).must_equal [:ins, :ins]
      end
    end

    describe '#reject' do
      it 'returns a Wires with the given Wire objects rejected' do
        smaller = wires.reject { |wire| wire.source.offset == 1 }
        _(smaller).must_equal Wires.new([
          Wire.from_arrays([fun_a, fun_a.outs, fun_a.outs[0]],
                           [fun_b, fun_b.ins,  fun_b.ins[1]])
        ])
      end
    end
  end
end
