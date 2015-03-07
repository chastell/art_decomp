require_relative '../test_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/seps'

module ArtDecomp
  describe Put do
    let(:put) { Put[%i(a - b)] }

    describe '.[]' do
      it 'creates a new Put with the given column' do
        put.must_equal Put.new(column: %i(a - b))
        Put[].must_equal Put.new(column: [])
      end
    end

    describe '.from_column' do
      it 'builds a Put from the given column' do
        Put.from_column(%i(0 1 -), codes: %i(0 1)).must_equal Put[%i(0 1 -)]
      end

      it 'can have the don’t-care and available codes overridden' do
        put = Put[%i(s1 s2 -), codes: %i(s1 s2 s3)]
        Put.from_column(%i(s1 s2 -), codes: %i(s1 s2 s3)).must_equal put
      end
    end

    describe '#==' do
      it 'compares two Puts by value' do
        assert put == put.dup
        assert put == Put[%i(a - b)]
        refute put == Put[%i(b - a)]
      end
    end

    describe '#binwidth' do
      it 'returns the binary width' do
        Put[].binwidth.must_equal 0
        Put[%i(a)].binwidth.must_equal 0
        Put[%i(a b)].binwidth.must_equal 1
        Put[%i(a b c)].binwidth.must_equal 2
        Put[%i(a b c d e f g h)].binwidth.must_equal 3
        Put[%i(a b c d e f g h i)].binwidth.must_equal 4
      end
    end

    describe '#codes' do
      it 'returns codes' do
        put.codes.must_equal %i(a b)
      end
    end

    describe '#inspect' do
      it 'returns self-initialising representation' do
        Put[%i(a - b)].inspect.must_equal 'ArtDecomp::Put[:a, :-, :b]'
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
