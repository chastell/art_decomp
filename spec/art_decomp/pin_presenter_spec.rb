require_relative '../spec_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/pin_presenter'
require_relative '../../lib/art_decomp/put'

module ArtDecomp
  describe PinPresenter do
    describe '#labels' do
      it 'returns an Array of [Object, String] pairs with the relevant label' do
        is = Puts.new([Put[a: 0, b: 1, c: 2]])
        function = Function.new(is: is)
        PinPresenter.new(Pin[function, :is, 0]).labels
          .must_equal [[function, 'is(0)'], [function, 'is(1)']]
      end
    end
  end
end
