require 'delegate'
require_relative 'function'
require_relative 'puts'

module ArtDecomp
  class FunctionSimplifier < SimpleDelegator
    def self.simplify(function)
      new(function).simplified
    end

    def simplified
      seps = os.map(&:seps).reduce :|
      Function.new Puts.new is: required_is(seps), os: os
    end

    private

    def required_is(seps)
      is.sort_by { |i| (i.seps & seps).size }.reverse.take_while do |i|
        empty = seps.empty?
        seps -= i.seps
        not empty
      end
    end
  end
end
