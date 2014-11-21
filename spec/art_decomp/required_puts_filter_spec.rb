require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/required_puts_filter'

module ArtDecomp
  describe RequiredPutsFilter do
    describe '.required' do
      it 'returns puts required by the given seps' do
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
        a   = Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]]
        b   = Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]]
        c   = Put[:'0' => B[0,2,4,6], :'1' => B[1,3,5,7]]
        anb = Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]]
        buc = Put[:'0' => B[0,4], :'1' => B[1,2,3,5,6,7]]
        one = Put[:'0' => B[0,1,2,3,4,5,6,7]]
        rpf = RequiredPutsFilter
        rpf.required(puts: [a, b, c], seps: anb.seps).must_equal [a, b]
        rpf.required(puts: [a, b, c], seps: buc.seps).must_equal [c, b]
        rpf.required(puts: [a, b, c], seps: one.seps).must_be_empty
      end
    end
  end
end
