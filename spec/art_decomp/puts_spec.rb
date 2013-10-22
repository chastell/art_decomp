require_relative '../spec_helper'

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

  describe '#is, #os, #qs, #ps' do
    it 'allows accessing given Put sets' do
      puts.is.must_equal is
      puts.os.must_equal os
      puts.ps.must_equal ps
      puts.qs.must_equal qs
    end
  end
end end
