require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/puts_set'

module ArtDecomp
  describe PutsSet do
    let(:is) { [stub(:put), stub(:put), stub(:put), stub(:put)] }
    let(:os) { [stub(:put), stub(:put), stub(:put)]             }
    let(:ps) { [stub(:put), stub(:put)]                         }
    let(:qs) { [stub(:put)]                                     }

    let(:puts_set) { PutsSet.new(is: is, os: os, ps: ps, qs: qs) }

    describe '#==' do
      it 'compares two PutsSets with regards to value' do
        puts_set.must_equal PutsSet.new(is: is, os: os, ps: ps, qs: qs)
        puts_set.wont_equal PutsSet.new(is: os, os: is, ps: ps, qs: qs)
      end
    end

    describe '#binwidths' do
      it 'returns binary widths of the given Put group' do
        puts_set = PutsSet.new(
          is: [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]],
          qs: [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]],
        )
        puts_set.binwidths(:is).must_equal [1, 2]
        puts_set.binwidths(:qs).must_equal [1, 2]
      end
    end

    describe '#is, #os, #qs, #ps' do
      it 'allows accessing given Put sets' do
        puts_set.is.must_equal is
        puts_set.os.must_equal os
        puts_set.ps.must_equal ps
        puts_set.qs.must_equal qs
      end
    end
  end
end
