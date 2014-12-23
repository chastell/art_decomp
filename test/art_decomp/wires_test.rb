require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/wire'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp
  describe Wires do
    let(:fun_a) { fake(:function) }
    let(:fun_b) { fake(:function) }
    let(:wires) do
      Wires.new([
        Wire.from_arrays([fun_a, :os, 0], [fun_b, :is, 1]),
        Wire.from_arrays([fun_a, :os, 1], [fun_b, :is, 0]),
      ])
    end

    describe '.from_array' do
      it 'constructs the Wires from a minimal Array' do
        Wires.from_array([[[fun_a, :os, 0], [fun_b, :is, 1]],
                          [[fun_a, :os, 1], [fun_b, :is, 0]]]).must_equal wires
      end
    end

    describe '.new' do
      it 'defaults to empty Wires' do
        Wires.new.must_equal Wires.new([])
      end
    end

    describe '#+' do
      it 'sums the two Wires objects' do
        wires_a = Wires.from_array([[[fun_a, :os, 0], [fun_b, :is, 1]]])
        wires_b = Wires.from_array([[[fun_a, :os, 1], [fun_b, :is, 0]]])
        (wires_a + wires_b).must_equal wires
      end
    end

    describe '#==' do
      it 'compares two Wires with regard to contents' do
        wires.must_equal Wires.new([
          Wire.from_arrays([fun_a, :os, 0], [fun_b, :is, 1]),
          Wire.from_arrays([fun_a, :os, 1], [fun_b, :is, 0]),
        ])
        wires.wont_equal Wires.new([
          Wire.from_arrays([fun_a, :os, 0], [fun_b, :is, 0]),
          Wire.from_arrays([fun_a, :os, 1], [fun_b, :is, 1]),
        ])
      end
    end

    describe '#flat_map' do
      it 'allows mapping its contents' do
        wires.flat_map(&:destination).map(&:index).must_equal [1, 0]
      end
    end
  end
end
