require_relative '../../lib/art_decomp/seps'

module ArtDecomp
  module PutBehaviour
    def self.included(spec_class)
      spec_class.class_eval do
        describe '.[]' do
          it 'creates a new put_class with the given column' do
            put_class[%i(a - b)].must_equal put_class.new(column: %i(a - b))
            put_class[[]].must_equal put_class.new(column: [])
          end
        end

        describe '.new' do
          it 'builds a put_class from the given column' do
            put = put_class.new(column: %i(0 1 -), codes: %i(0 1))
            put.must_equal put_class[%i(0 1 -)]
          end

          it 'can have the don’t-care and available codes overridden' do
            put_brackets = put_class[%i(s1 s2 -), codes: %i(s1 s2 s3)]
            put_new = put_class.new(column: %i(s1 s2 -), codes: %i(s1 s2 s3))
            put_new.must_equal put_brackets
          end
        end

        describe '#==' do
          it 'compares two put_class instances by value' do
            assert put_class[%i(a - b)] == put_class[%i(a - b)].dup
            refute put_class[%i(a - b)] == put_class[%i(b - a)]
          end
        end

        describe '#binwidth' do
          it 'returns the binary width' do
            put_class[[]].binwidth.must_equal 0
            put_class[%i(a)].binwidth.must_equal 0
            put_class[%i(a b)].binwidth.must_equal 1
            put_class[%i(a b c)].binwidth.must_equal 2
            put_class[%i(a b c d e f g h)].binwidth.must_equal 3
            put_class[%i(a b c d e f g h i)].binwidth.must_equal 4
          end
        end

        describe '#codes' do
          it 'returns codes' do
            put_class[%i(a - b)].codes.must_equal %i(a b)
          end
        end

        describe '#inspect' do
          it 'returns self-initialising representation' do
            put_class[%i(a - b)].inspect
              .must_equal put_class.to_s + '[[:a, :-, :b], codes: [:a, :b]]'
            put_class[%i(1 0)].inspect
              .must_equal put_class.to_s + '[[:"1", :"0"], codes: [:"0", :"1"]]'
          end
        end

        describe '#seps' do
          it 'returns the put_class’s Seps' do
            put_class[%i(a - b)].seps.must_equal Seps.new([0b100, 0b000, 0b001])
          end
        end
      end
    end
  end
end
