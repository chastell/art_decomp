require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp                          # rubocop:disable Metrics/ModuleLength
  describe Puts do
    let(:a0b1)   { Put[%i(a b)]           }
    let(:a0b1c2) { Put[%i(a b c)]         }
    let(:a1b0)   { Put[%i(b a)]           }
    let(:puts)   { Puts.new([a0b1, a1b0]) }

    describe '.from_columns' do
      it 'creates Puts from an Array of columns' do
        puts = Puts.from_columns([%i(a b -), %i(b - c)], codes: %i(a b c))
        _(puts).must_equal Puts.new([Put[%i(a b -), codes: %i(a b c)],
                                     Put[%i(b - c), codes: %i(a b c)]])
      end

      it 'infers codes on a per-column basis' do
        puts = Puts.from_columns([%i(0 1 -), %i(a b c)])
        _(puts).must_equal Puts.new([Put[%i(0 1 -), codes: %i(0 1)],
                                     Put[%i(a b c), codes: %i(a b c)]])
      end
    end

    describe '.from_seps' do
      it 'creates Puts from the given required and allowed Seps' do
        allowed = Seps.new([
          0b110110100,
          0b110111000,
          0b110111001,
          0b110110110,
          0b010001111,
          0b110001111,
          0b000000000,
          0b100111111,
          0b010101111,
        ])
        required = Seps.new([
          0b010000000,
          0b010000000,
          0b110000000,
          0b010000000,
          0b000000000,
          0b110000000,
          0b000000000,
          0b000101111,
          0b000100100,
        ])
        puts = Puts.from_seps(allowed: allowed, required: required, size: 9)
        _(puts).must_equal Puts.from_columns([%i(b b b b - b - a a)])
      end

      it 'honours allowed separations' do
        allowed = Seps.new([
          0b1010,
          0b0101,
          0b0010,
          0b0001,
        ])
        required = Seps.new([
          0b1000,
          0b0100,
          0b0010,
          0b0001,
        ])
        puts = Puts.from_seps(allowed: allowed, required: required, size: 4)
        _(puts).must_equal Puts.from_columns([%i(a b a -), %i(a - - b)])
      end
    end

    describe '#==' do
      it 'compares Puts according to contents' do
        _(Puts.new([a0b1])).must_equal Puts.new([a0b1])
        _(Puts.new([a0b1])).wont_equal Puts.new([a1b0])
      end
    end

    describe '#&' do
      it 'creates an intersection of Puts' do
        _(puts & Puts.new([a0b1])).must_equal Puts.new([a0b1])
        _(puts & Puts.new([a1b0])).must_equal Puts.new([a1b0])
      end
    end

    describe '#+' do
      it 'creates a sum of Puts' do
        _(Puts.new([a0b1]) + Puts.new([a1b0])).must_equal puts
      end
    end

    describe '#-' do
      it 'creates a difference of Puts' do
        _(puts - Puts.new([a0b1])).must_equal Puts.new([a1b0])
      end
    end

    describe '#[]' do
      it 'returns the Put at the given index' do
        _(puts[0]).must_equal a0b1
        _(puts[1]).must_equal a1b0
      end

      it 'returns the Puts from the given Range' do
        _(puts[0..1]).must_equal puts
      end
    end

    describe '#binwidth' do
      it 'returns the binwidth of all the Puts combined' do
        {
          Puts.new                 => 0,
          Puts.new([a0b1])         => 1,
          Puts.new([a0b1, a1b0])   => 2,
          Puts.new([a1b0, a0b1c2]) => 3,
        }.each do |puts, binwidth|
          _(puts.binwidth).must_equal binwidth
        end
      end
    end

    describe '#combination' do
      it 'yields subsequent Puts with different Put combinations' do
        puts = Puts.from_columns([%i(a b c), %i(b a c), %i(c a b)])
        _(puts.combination(2)).must_be_kind_of Enumerator
        _(puts.combination(2).to_a).must_equal [
          Puts.from_columns([%i(a b c), %i(b a c)]),
          Puts.from_columns([%i(a b c), %i(c a b)]),
          Puts.from_columns([%i(b a c), %i(c a b)]),
        ]
      end
    end

    describe '#each' do
      it 'yields subsequent Puts' do
        array = puts.each.with_object([]) { |put, arr| arr << put }
        _(array).must_equal [a0b1, a1b0]
      end
    end

    describe '#empty?' do
      it 'is a predicate whether the Puts are empty' do
        assert Puts.new.empty?
        refute puts.empty?
      end
    end

    describe '#index' do
      it 'returns the index of the given Put' do
        _(puts.index(a0b1)).must_equal 0
        _(puts.index(a1b0)).must_equal 1
      end
    end

    describe '#inspect' do
      it 'returns a self-initialising representation' do
        _(puts.inspect).must_equal 'ArtDecomp::Puts.new([' \
          'ArtDecomp::Put[%i(a b), codes: %i(a b)], '   \
          'ArtDecomp::Put[%i(b a), codes: %i(a b)]])'
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
        _(puts.size).must_equal 2
      end
    end

    describe '#sort_by' do
      it 'returns a Puts sorted according to the passed block' do
        random = Puts.from_columns([%i(a a a), %i(a b c), %i(a b b)])
        sorted = Puts.from_columns([%i(a b c), %i(a b b), %i(a a a)])
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

    describe '#to_s' do
      it 'returns a readable representation' do
        _(puts.to_s).must_equal <<-end.dedent
          a b
          b a
        end
      end
    end

    describe '#uniq' do
      it 'returns a Puts with only unique members' do
        _(Puts.new([a0b1, a1b0, a0b1]).uniq).must_equal puts
      end
    end
  end
end
