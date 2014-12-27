require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Pin do
    describe '#inspect' do
      it 'returns self-initialising representation' do
        is = Puts.new([Put[a: 0, b: 1, c: 2]])
        function = Function.new(is: is)
        Pin[function, :is, 0].inspect
          .must_equal 'ArtDecomp::Pin' \
                      '[ArtDecomp::Function(ArtDecomp::Arch[2,0]), :is, 0]'
      end
    end
  end
end
