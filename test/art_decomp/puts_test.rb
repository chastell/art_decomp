require_relative '../test_helper'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe Puts do
    let(:a0b1)   { Put[%i(a b)]           }
    let(:a0b1c2) { Put[%i(a b c)]         }
    let(:a1b0)   { Put[%i(b a)]           }
    let(:puts)   { Puts.new([a0b1, a1b0]) }

    describe '.from_columns' do
      it 'creates Puts from an Array of columns' do
        puts = Puts.from_columns([%i(a b -), %i(b - c)], codes: %i(a b c))
        puts.must_equal Puts.new([Put[%i(a b -), codes: %i(a b c)],
                                  Put[%i(b - c), codes: %i(a b c)]])
      end

      it 'infers codes on a per-column basis' do
        puts = Puts.from_columns([%i(0 1 -), %i(a b c)])
        puts.must_equal Puts.new([Put[%i(0 1 -), codes: %i(0 1)],
                                  Put[%i(a b c), codes: %i(a b c)]])
      end
    end

    describe '#==' do
      it 'compares Puts according to contents' do
        Puts.new([a0b1]).must_equal Puts.new([a0b1])
        Puts.new([a0b1]).wont_equal Puts.new([a1b0])
      end
    end

    describe '#&' do
      it 'creates an intersection of Puts' do
        (puts & Puts.new([a0b1])).must_equal Puts.new([a0b1])
        (puts & Puts.new([a1b0])).must_equal Puts.new([a1b0])
      end
    end

    describe '#+' do
      it 'creates a sum of Puts' do
        (Puts.new([a0b1]) + Puts.new([a1b0])).must_equal puts
      end
    end

    describe '#[]' do
      it 'returns the Put at the given index' do
        puts[0].must_equal a0b1
        puts[1].must_equal a1b0
      end

      it 'returns the Puts from the given Range' do
        puts[0..1].must_equal puts
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
          puts.binwidth.must_equal binwidth
        end
      end
    end

    describe '#each' do
      it 'yields subsequent Puts' do
        puts.each.with_object([]) { |p, ary| ary << p }.must_equal [a0b1, a1b0]
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
        puts.index(a0b1).must_equal 0
        puts.index(a1b0).must_equal 1
      end
    end

    describe '#inspect' do
      it 'returns a self-initialising representation' do
        puts.inspect.must_equal 'ArtDecomp::Puts.new([' \
          'ArtDecomp::Put[%i(a b), codes: %i(a b)], '   \
          'ArtDecomp::Put[%i(b a), codes: %i(a b)]])'
      end
    end

    describe '#seps' do
      it 'returns the combined Seps of all the Puts' do
        seps = Seps.new([0b110, 0b101, 0b011])
        Puts.new([Put[%i(a a b)], Put[%i(a b b)]]).seps.must_equal seps
      end
    end

    describe '#size' do
      it 'returns the number of Puts' do
        Puts.new.size.must_equal 0
        puts.size.must_equal 2
      end
    end

    describe '#uniq' do
      it 'returns a Puts with only unique members' do
        Puts.new([a0b1, a1b0, a0b1]).uniq.must_equal puts
      end
    end
  end
end
