# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/required_puts_filter'

module ArtDecomp
  describe RequiredPutsFilter do
    describe '.call' do
      let(:a)   { Put[%i[0 0 0 0 1 1 1 1]] }
      let(:b)   { Put[%i[0 0 1 1 0 0 1 1]] }
      let(:c)   { Put[%i[0 1 0 1 0 1 0 1]] }
      let(:rpf) { RequiredPutsFilter       }

      it 'returns an Array of Puts required by the given Seps' do
        anb  = Put[%i[0 0 0 0 0 0 1 1]]
        puts = rpf.call(puts: Puts.new([a, b, c]), required_seps: anb.seps)
        _(puts).must_equal Puts.new([a, b])
      end

      it 'returns an empty Array if there are no Seps' do
        empty = Put[%i[1 1 1 1 1 1 1 1]].seps
        puts  = rpf.call(puts: Puts.new([a, b, c]), required_seps: empty)
        _(puts).must_be_empty
      end

      it 'preserves Put order' do
        seps = Put[%i[0 1 1 1]].seps
        two  = Put[%i[0 1 1 0]]
        one  = Put[%i[0 0 0 1]]
        puts = rpf.call(puts: Puts.new([one, two]), required_seps: seps)
        _(puts).must_equal Puts.new([one, two])
      end
    end
  end
end
