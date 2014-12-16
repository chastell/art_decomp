require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/wire'
require_relative '../../lib/art_decomp/wires'
require_relative '../../lib/art_decomp/wires_presenter'
require_relative '../../lib/art_decomp/put'

module ArtDecomp
  describe WiresPresenter do
    describe '#labels' do
      it 'returns an Array of labels from Wires' do
        producer = Function.new(os: Puts.new([Put[a: 0, b: 1, c: 2],
                                              Put[a: 1, b: 0]]))
        consumer = Function.new(is: Puts.new([Put[a: 2, b: 1, c: 1],
                                              Put[a: 0, b: 1]]))
        wires = Wires.new([Wire[Pin[producer, :os, 0], Pin[consumer, :is, 0]],
                           Wire[Pin[producer, :os, 1], Pin[consumer, :is, 1]]])
        WiresPresenter.new(wires).labels.must_equal [
          [[producer, 'os(0)'], [consumer, 'is(0)']],
          [[producer, 'os(1)'], [consumer, 'is(1)']],
          [[producer, 'os(2)'], [consumer, 'is(2)']],
        ]
      end
    end
  end
end
