require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp describe Puts do
  let(:is)   { [stub(:put), stub(:put), stub(:put), stub(:put)] }
  let(:os)   { [stub(:put), stub(:put), stub(:put)]             }
  let(:ps)   { [stub(:put), stub(:put)]                         }
  let(:qs)   { [stub(:put)]                                     }
  let(:puts) { Puts.new is: is, os: os, ps: ps, qs: qs          }

  describe '#==' do
    it 'compares two Puts with regards to value' do
      puts.must_equal Puts.new is: is, os: os, ps: ps, qs: qs
      puts.wont_equal Puts.new is: os, os: is, ps: ps, qs: qs
    end
  end

  describe '#binwidths' do
    it 'returns binary widths of the given Put group' do
      puts = Puts.new(
        is: [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]],
        qs: [Put[a: B[0,1], b: B[1,2]], Put[a: B[0], b: B[1], c: B[2]]],
      )
      puts.binwidths(:is).must_equal [1, 2]
      puts.binwidths(:qs).must_equal [1, 2]
    end
  end

  describe '#is, #os, #qs, #ps' do
    it 'allows accessing given Put sets' do
      puts.is.must_equal is
      puts.os.must_equal os
      puts.ps.must_equal ps
      puts.qs.must_equal qs
    end
  end
end end
