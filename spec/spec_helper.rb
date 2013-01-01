require 'bundler/setup'
require 'minitest/autorun'
require_relative '../lib/art_decomp'

class String
  def dedent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end
