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
        Put[a: 1, b: 2, c: 4].binwidth.must_equal 2
        Put[a: 1, b: 2, c: 4, d: 8, e: 16, f: 32, g: 64, h: 128].binwidth
          .must_equal 3
        Put[a: 1, b: 2, c: 4, d: 8, e: 16, f: 32, g: 64, h: 128, i: 256]
          .binwidth.must_equal 4
      end
    end

    describe '#codes' do
      it 'returns codes' do
        put.codes.must_equal %i(a b)
      end
    end

    describe '#inspect' do
      it 'returns self-initialising representation' do
        Put[a: B[0,1], b: B[1,2]].inspect
          .must_equal 'ArtDecomp::Put[:a, :-, :b]'
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
