require_relative '../../lib/art_decomp/seps'

module ArtDecomp
  module PutBehaviour
    def self.included(spec_class)
      spec_class.class_eval do
        describe '.[]' do
          it 'creates a new put_class with the given column' do
            _(put_class[%i[a - b]]).must_equal put_class.new(column: %i[a - b])
            _(put_class[[]]).must_equal put_class.new(column: [])
          end
        end

        describe '.new' do
          it 'builds a put_class from the given column' do
            put = put_class.new(column: %i[0 1 -], codes: %i[0 1])
            _(put).must_equal put_class[%i[0 1 -]]
          end

          it 'can have the don’t-care and available codes overridden' do
            put_brackets = put_class[%i[s1 s2 -], codes: %i[s1 s2 s3]]
            put_new = put_class.new(column: %i[s1 s2 -], codes: %i[s1 s2 s3])
            _(put_new).must_equal put_brackets
          end
        end

        describe '#<=>' do
          it 'allows sorting put_class instances by column and codes' do
            ab  = put_class[%i[a b]]
            abc = put_class[%i[a b], codes: %i[a b c]]
            ba  = put_class[%i[b a]]
            _([ba, abc, ab].sort).must_equal [ab, abc, ba]
          end
        end

        describe '#==' do
          it 'compares two put_class instances by value' do
            _(put_class[%i[a - b]]).must_equal put_class[%i[a - b]]
            _(put_class[%i[a - b]]).wont_equal put_class[%i[b - a]]
          end
        end

        describe '#binwidth' do
          it 'returns the binary width' do
            _(put_class[[]].binwidth).must_equal 0
            _(put_class[%i[a]].binwidth).must_equal 0
            _(put_class[%i[a b]].binwidth).must_equal 1
            _(put_class[%i[a b c]].binwidth).must_equal 2
            _(put_class[%i[a b c d e f g h]].binwidth).must_equal 3
            _(put_class[%i[a b c d e f g h i]].binwidth).must_equal 4
          end
        end

        describe '#codes' do
          it 'returns codes' do
            _(put_class[%i[a - b]].codes).must_equal %i[a b]
          end
        end

        describe '#eql?' do
          it 'discriminates between two otherwise-equal puts' do
            refute put_class[%i[a b]].eql?(put_class[%i[a b]])
          end
        end

        describe '#hash' do
          it 'discriminates between two otherwise-equal puts' do
            _(put_class[%i[a b]].hash).wont_equal put_class[%i[a b]].hash
          end
        end

        describe '#seps' do
          it 'returns the put_class’s Seps' do
            seps = put_class[%i[a - b]].seps
            _(seps).must_equal Seps.new([0b100, 0b000, 0b001])
          end
        end

        describe '#size' do
          it 'returns the length of the column' do
            _(put_class[%i[a - b]].size).must_equal 3
          end
        end
      end
    end
  end
end
