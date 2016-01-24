require_relative '../test_helper'
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

      let(:a)   { Put[%i(0 0 0 0 1 1 1 1)] }
      let(:b)   { Put[%i(0 0 1 1 0 0 1 1)] }
      let(:c)   { Put[%i(0 1 0 1 0 1 0 1)] }
      let(:abc) { Puts.new([a, b, c])      }
      let(:rpf) { RequiredPutsFilter       }

      it 'returns an Array of Puts required by the given Seps' do
        anb  = Put[%i(0 0 0 0 0 0 1 1)]
        puts = rpf.required(puts: abc, required_seps: anb.seps)
        _(puts).must_equal Puts.new([a, b])
      end

      it 'preserves Put order' do
        three = Put[%i(0 1 1 1)].seps
        two   = Put[%i(0 1 1 0)]
        one   = Put[%i(0 0 0 1)]
        puts = rpf.required(puts: Puts.new([one, two]), required_seps: three)
        _(puts).must_equal Puts.new([one, two])
      end

      it 'returns an empty Array if there are no Seps' do
        one  = Put[%i(1 1 1 1 1 1 1 1)]
        puts = rpf.required(puts: abc, required_seps: one.seps)
        _(puts).must_be_empty
      end
    end
  end
end
