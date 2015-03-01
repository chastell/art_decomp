require_relative '../test_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/seps'

module ArtDecomp
  describe Put do
    let(:put) { Put[a: B[0,1], b: B[1,2]] }

    describe '.[]' do
      it 'creates a new Put with the given blanket' do
        put.must_equal Put.new(blanket: { a: B[0,1], b: B[1,2] })
        Put[].must_equal Put.new(blanket: {})
      end
    end

    describe '.from_column' do
      it 'builds a Put from the given column' do
        Put.from_column(%i(0 1 -), codes: %i(0 1), dont_care: :-)
          .must_equal Put[:'0' => B[0,2], :'1' => B[1,2]]
      end

      it 'can have the don’t-care and available codes overridden' do
        Put.from_column(%i(s1 s2 *), codes: %i(s1 s2 s3), dont_care: :*)
          .must_equal Put[s1: B[0,2], s2: B[1,2], s3: B[2]]
      end
    end

    describe '#==' do
      it 'compares two Puts by value' do
        assert put == put.dup
        assert put == Put[b: B[1,2], a: B[0,1]]
        refute put == Put[a: B[1,2], b: B[0,1]]
      end
    end

    describe '#binwidth' do
      it 'returns the binary width' do
        Put[].binwidth.must_equal 0
        Put[a: 1].binwidth.must_equal 0
        Put[a: 1, b: 2].binwidth.must_equal 1
        Put[a: 1, b: 2, c: 3].binwidth.must_equal 2
        Put[a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8].binwidth
          .must_equal 3
        Put[a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9].binwidth
          .must_equal 4
      end
    end

    describe '#blocks' do
      it 'returns blocks' do
        put.blocks.must_equal [B[0,1], B[1,2]]
      end
    end

    describe '#codes' do
      it 'returns codes' do
        put.codes.must_equal %i(a b)
      end

      it 'allows requesting just certain codes' do
        put.codes { |code, _| code < :b }.must_equal [:a]
        put.codes { |_, block| (block & B[2]).nonzero? }.must_equal [:b]
      end
    end

    describe '#inspect' do
      it 'returns self-initialising representation' do
        Put[a: B[0,1], b: B[1,2]].inspect
          .must_equal 'ArtDecomp::Put[:a => B[0,1], :b => B[1,2]]'
      end
    end

    describe '#seps' do
      it 'returns the Put’s Seps' do
        put.seps.must_equal Seps.from_blocks([B[0,1], B[1,2]])
      end
    end

    describe '#size' do
      it 'returns size' do
        put.size.must_equal 2
      end
    end
  end
end
