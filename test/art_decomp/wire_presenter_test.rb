require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/wire'
require_relative '../../lib/art_decomp/wire_presenter'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe WirePresenter do
    describe '#labels' do
      it 'returns an Array of [Object, String] pairs from src and dst Pins' do
        prod_os  = Puts.new([Put[a: 0, b: 1, c: 2]])
        cons_is  = Puts.new([Put[a: 2, b: 1, c: 1]])
        producer = Function.new(os: prod_os)
        consumer = Function.new(is: cons_is)
        wire     = Wire.from_arrays([producer, :os, 0], [consumer, :is, 0])
        WirePresenter.new(wire).labels.must_equal [
          [[producer, 'os(0)'], [consumer, 'is(0)']],
          [[producer, 'os(1)'], [consumer, 'is(1)']],
        ]
      end
    end
  end
end
