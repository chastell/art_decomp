require_relative 'art_decomp/circuit'
require_relative 'art_decomp/circuit_presenter'
require_relative 'art_decomp/function'
require_relative 'art_decomp/function_presenter'
require_relative 'art_decomp/kiss_decomposer'
require_relative 'art_decomp/kiss_parser'
require_relative 'art_decomp/pin'

def width_of put
  Math.log2(put.size).ceil
end
