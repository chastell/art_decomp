require_relative '../spec_helper'

module ArtDecomp describe Puts do
  let(:is)   { [stub(:put), stub(:put), stub(:put)] }
  let(:os)   { [stub(:put), stub(:put)]             }
  let(:puts) { Puts.new is: is, os: os              }

  describe '#==' do
    it 'compares two Puts with regards to value' do
      puts.must_equal Puts.new is: is, os: os
      puts.wont_equal Puts.new is: os, os: is
    end
  end

  describe '#ss' do
    it 'allows accessing given Put sets' do
      puts.is.must_equal is
    end

    it 'raises if the given Put set wasn’t defined' do
      -> { puts.ps }.must_raise NoMethodError
      assert Puts.new(ps: nil).ps.nil?
    end
  end

  describe '#respond_to?' do
    it 'is a predicate whether a given Put set exists' do
      assert puts.respond_to? :is
      refute puts.respond_to? :ps
    end
  end
end end
