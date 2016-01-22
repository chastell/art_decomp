require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp                          # rubocop:disable Metrics/ModuleLength
  describe Puts do
    let(:ab)    { Put[%i(a b)]       }
    let(:abc)   { Put[%i(a b c)]     }
    let(:ba)    { Put[%i(b a)]       }
    let(:ab_ba) { Puts.new([ab, ba]) }

    describe '.[]' do
      it 'creates Puts from a list of columns' do
        puts = Puts[%i(a b -), %i(b - c)]
        _(puts).must_equal Puts.new([Put[%i(a b -), codes: %i(a b)],
                                     Put[%i(b - c), codes: %i(b c)]])
      end

      it 'infers codes on a per-column basis' do
        puts = Puts[%i(0 1 -), %i(a b c)]
        _(puts).must_equal Puts.new([Put[%i(0 1 -), codes: %i(0 1)],
                                     Put[%i(a b c), codes: %i(a b c)]])
      end
    end

    describe '#==' do
      it 'compares Puts according to contents' do
        _(Puts.new([Put[%i(a b)]])).must_equal Puts.new([Put[%i(a b)]])
        _(Puts.new([Put[%i(a b)]])).wont_equal Puts.new([Put[%i(b a)]])
      end
    end

    describe '#&' do
      it 'creates an intersection of Puts' do
        _(ab_ba & Puts.new([ab])).must_equal Puts.new([ab])
        _(ab_ba & Puts.new([ba])).must_equal Puts.new([ba])
      end

      it 'is based on hash/eql? calls' do
        _(ab_ba & Puts[%i(a b)]).must_be :empty?
        _(ab_ba & Puts[%i(b a)]).must_be :empty?
      end
    end

    describe '#+' do
      it 'creates a sum of Puts' do
        _(Puts.new([ab]) + Puts.new([ba])).must_equal ab_ba
      end
    end

    describe '#-' do
      it 'creates a difference of Puts' do
        _(ab_ba - Puts.new([ab])).must_equal Puts.new([ba])
      end

      it 'is based on hash/eql? calls' do
        _(ab_ba - Puts[%i(a b)]).must_equal ab_ba
      end
    end

    describe '#[]' do
      it 'returns the Put at the given index' do
        _(ab_ba[0]).must_equal ab
        _(ab_ba[1]).must_equal ba
      end

      it 'returns the Puts from the given Range' do
        _(ab_ba[0..1]).must_equal ab_ba
      end
    end

    describe '#binwidth' do
      it 'returns the binwidth of all the Puts combined' do
        {
          Puts.new            => 0,
          Puts.new([ab])      => 1,
          Puts.new([ab, ba])  => 2,
          Puts.new([ba, abc]) => 3,
        }.each do |puts, binwidth|
          _(puts.binwidth).must_equal binwidth
        end
      end
    end

    describe '#combination' do
      it 'yields subsequent Puts with different Put combinations' do
        puts = Puts[%i(a b c), %i(b a c), %i(c a b)]
        _(puts.combination(2)).must_be_kind_of Enumerator
        _(puts.combination(2).to_a).must_equal [Puts[%i(a b c), %i(b a c)],
                                                Puts[%i(a b c), %i(c a b)],
                                                Puts[%i(b a c), %i(c a b)]]
      end
    end

    describe '#each' do
      it 'yields subsequent Puts' do
        array = ab_ba.each.with_object([]) { |put, arr| arr << put }
        _(array).must_equal [ab, ba]
      end
    end

    describe '#empty?' do
      it 'is a predicate whether the Puts are empty' do
        assert Puts.new.empty?
        refute ab_ba.empty?
      end
    end

    describe '#eql?' do
      it 'compares Puts according to contents' do
        assert Puts.new([Put[%i(a b)]]).eql?(Puts.new([Put[%i(a b)]]))
        refute Puts.new([Put[%i(a b)]]).eql?(Puts.new([Put[%i(b a)]]))
      end
    end

    describe '#hash' do
      it 'compares Puts according to contents' do
        _(Puts.new([Put[%i(a b)]]).hash)
          .must_equal Puts.new([Put[%i(a b)]]).hash
        _(Puts.new([Put[%i(a b)]]).hash)
          .wont_equal Puts.new([Put[%i(b a)]]).hash
        _(Puts.new([Put[%i(a b)]]).hash)
          .wont_equal Puts.new([Put[%i(a b), codes: %i(a b c)]]).hash
      end
    end

    describe '#include?' do
      it 'is a predicate whether the given Put is included based on identity' do
        assert ab_ba.include?(ab)
        refute ab_ba.include?(Put[%i(a b)])
      end
    end

    describe '#index' do
      it 'returns the index of the given Put based on its identity' do
        ab1  = Put[%i(a b)]
        ab2  = Put[%i(a b)]
        ba   = Put[%i(b a)]
        puts = Puts.new([ab1, ba, ab2])
        _(puts.index(ab1)).must_equal 0
        _(puts.index(ba)).must_equal 1
        _(puts.index(ab2)).must_equal 2
      end
    end

    describe '#seps' do
      it 'returns the combined Seps of all the Puts' do
        seps = Seps.new([0b110, 0b101, 0b011])
        _(Puts.new([Put[%i(a a b)], Put[%i(a b b)]]).seps).must_equal seps
      end

      it 'returns empty Seps for empty Puts' do
        _(Puts.new.seps).must_equal Seps.new
      end
    end

    describe '#size' do
      it 'returns the number of Puts' do
        _(Puts.new.size).must_equal 0
        _(ab_ba.size).must_equal 2
      end
    end

    describe '#sort' do
      it 'returns a Puts with sorted members' do
        unsorted = Puts[%i(b a), %i(b c), %i(a b)]
        sorted   = Puts[%i(a b), %i(b a), %i(b c)]
        _(unsorted.sort).must_equal sorted
      end
    end

    describe '#sort_by' do
      it 'returns a Puts sorted according to the passed block' do
        random = Puts[%i(a a a), %i(a b c), %i(a b b)]
        sorted = Puts[%i(a b c), %i(a b b), %i(a a a)]
        _(random.sort_by).must_be_kind_of Enumerator
        _(random.sort_by { |put| -put.seps.count }).must_equal sorted
      end
    end

    describe '#take_while' do
      it 'returns a Puts consisting of first Puts matching the block' do
        aaa = Put[%i(a a a)]
        abb = Put[%i(a b b)]
        abc = Put[%i(a b c)]
        puts = Puts.new([aaa, abc, abb])
        _(puts.take_while).must_be_kind_of Enumerator
        _(puts.take_while { |put| put.seps.empty? }).must_equal Puts.new([aaa])
        _(puts.take_while { |put| put != abb }).must_equal Puts.new([aaa, abc])
      end
    end

    describe '#uniq' do
      it 'returns a Puts with only unique members' do
        _(Puts.new([ab, ba, ab]).uniq).must_equal ab_ba
      end

      it 'is based on == comparison' do
        _(Puts[%i(a b), %i(b a), %i(a b)].uniq).must_equal ab_ba
      end

      it 'consider code differences' do
        puts = Puts.new([Put[%i(a b)], Put[%i(a b), codes: %i(a b c)]])
        _(puts.uniq).must_equal puts
      end
    end
  end
end
