require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Pin do
    describe '#inspect' do
      it 'returns self-initialising representation' do
        ins = Puts.from_columns([[%i(a b c)]])
        function = Function.new(ins: ins, outs: Puts.new)
        Pin[function, :ins, 0, 2, 0].inspect
          .must_equal 'ArtDecomp::Pin'                               \
                      '[ArtDecomp::Function(ArtDecomp::Arch[2,0]), ' \
                      ':ins, 0, 2, 0]'
      end
    end
  end
end
