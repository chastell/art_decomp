require_relative '../spec_helper'

module ArtDecomp describe Puts do
  describe '#ss' do
    it 'allows accessing given Put sets' do
      is = [stub(:put), stub(:put), stub(:put)]
      os = [stub(:put), stub(:put)]
      Puts.new(is: is, os: os).is.must_equal is
    end
  end

  describe '#respond_to?' do
    it 'is a predicate whether a given Put set exists' do
      is = [stub(:put), stub(:put), stub(:put)]
      os = [stub(:put), stub(:put)]
      assert Puts.new(is: is, os: os).respond_to? :is
      refute Puts.new(is: is, os: os).respond_to? :ps
    end
  end
end end
