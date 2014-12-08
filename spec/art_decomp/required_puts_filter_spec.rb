require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/required_puts_filter'

module ArtDecomp
  describe RequiredPutsFilter do
    describe '.required' do
      #   | a b c | anb buc one
      # --+-------+------------
      # 0 | 0 0 0 |  0   0   1
      # 1 | 0 0 1 |  0   1   1
      # 2 | 0 1 0 |  0   1   1
      # 3 | 0 1 1 |  0   1   1
      # 4 | 1 0 0 |  0   0   1
      # 5 | 1 0 1 |  0   1   1
      # 6 | 1 1 0 |  1   1   1
      # 7 | 1 1 1 |  1   1   1

      let(:a) { Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]] }
      let(:b) { Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]] }
      let(:c) { Put[:'0' => B[0,2,4,6], :'1' => B[1,3,5,7]] }
      let(:rpf) { RequiredPutsFilter }

      it 'returns an Array of Puts required by the given Seps' do
        anb = Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]]
        rpf.required(puts: Puts.new([a, b, c]), required_seps: anb.seps)
          .must_equal Puts.new([a, b])
      end

      it 'preserves Put order' do
        buc = Put[:'0' => B[0,4], :'1' => B[1,2,3,5,6,7]]
        rpf.required(puts: Puts.new([a, b, c]), required_seps: buc.seps)
          .must_equal Puts.new([b, c])
      end

      it 'returns an empty Array if there are no Seps' do
        one = Put[:'1' => B[0,1,2,3,4,5,6,7]]
        rpf.required(puts: Puts.new([a, b, c]), required_seps: one.seps)
          .must_be_empty
      end
    end
  end
end
