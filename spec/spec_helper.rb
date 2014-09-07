require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/pride'
require 'bogus/minitest/spec'
require 'art_decomp'

Bogus.configure { |config| config.search_modules << ArtDecomp }

class String
  def dedent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end
