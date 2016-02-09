# frozen_string_literal: true

ENV['MT_NO_EXPECTATIONS'] = 'true'
require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/pride'
require 'bogus/minitest/spec'
require_relative '../lib/art_decomp'
require_relative '../lib/art_decomp/circuit_presenter'
require_relative '../lib/art_decomp/fsm_kiss_parser'
require_relative '../lib/art_decomp/kiss_parser'

Bogus.configure { |config| config.search_modules << ArtDecomp }

Bogus.fakes do
  fake :circ_kiss_parser,
       as: :class,
       class: -> { [ArtDecomp::KISSParser, ArtDecomp::FSMKISSParser] }
end
