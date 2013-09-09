require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'bogus/minitest/spec'
require 'art_decomp'

Bogus.configure { |config| config.search_modules << ArtDecomp }

class String
  def dedent
    gsub(%r(^#{self[/\A\s*/]}), '')
  end
end
