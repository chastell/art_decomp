require_relative '../test_helper'
require_relative '../../lib/art_decomp/function_simplifier'
require_relative '../../lib/art_decomp/kiss_parser'

module ArtDecomp
  describe FunctionSimplifier do
    describe '.call' do
      it 'returns the simplest implementation of a Function' do
        abc_anb = KISSParser.function_for <<-end
          000 0
          001 0
          010 0
          011 0
          100 0
          101 0
          110 1
          111 1
        end
        ab_anb = KISSParser.function_for <<-end
          00 0
          00 0
          01 0
          01 0
          10 0
          10 0
          11 1
          11 1
        end
        _(FunctionSimplifier.call(abc_anb)).must_equal ab_anb
      end

      it 'maintains put order' do
        abc_buc = KISSParser.function_for <<-end
          000 0
          001 1
          010 1
          011 1
          100 0
          101 1
          110 1
          111 1
        end
        bc_buc = KISSParser.function_for <<-end
          00 0
          01 1
          10 1
          11 1
          00 0
          01 1
          10 1
          11 1
        end
        _(FunctionSimplifier.call(abc_buc)).must_equal bc_buc
      end

      it 'does not modify Functions that are the simplest already' do
        ab_anb = KISSParser.function_for <<-end
          00 0
          00 0
          01 0
          01 0
          10 0
          10 0
          11 1
          11 1
        end
        _(FunctionSimplifier.call(ab_anb)).must_equal ab_anb
      end
    end
  end
end
