require_relative 'art_decomp/b'
require_relative 'art_decomp/circuit'
require_relative 'art_decomp/circuit_presenter'
require_relative 'art_decomp/decomposer'
require_relative 'art_decomp/function'
require_relative 'art_decomp/function_presenter'
require_relative 'art_decomp/kiss_decomposer'
require_relative 'art_decomp/kiss_parser'
require_relative 'art_decomp/pin'
require_relative 'art_decomp/put'

module ArtDecomp
  def self.width_of put
    Math.log2(put.size).ceil
  end
end
