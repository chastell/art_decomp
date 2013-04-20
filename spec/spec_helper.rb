require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/art_decomp'

class String
  def dedent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end

class Double < OpenStruct
  def initialize opts
    callables, values = opts.partition { |_, val| val.is_a? Proc }
    super Hash[values]
    callables.each do |name, callable|
      define_singleton_method(name) { |*args| callable.call(*args) }
    end
  end

  alias ==   equal?
  alias eql? equal?
end

def double opts = {}
  Double.new opts
end
