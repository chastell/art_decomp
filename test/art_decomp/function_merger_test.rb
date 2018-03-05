require_relative '../test_helper'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_merger'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe FunctionMerger do
    describe '.merge' do
      let(:a)    { %i[0 0 0 0 1 1 1 1] }
      let(:b)    { %i[0 0 1 1 0 0 1 1] }
      let(:c)    { %i[0 1 0 1 0 1 0 1] }
      let(:anb)  { %i[0 0 0 0 0 0 1 1] }
      let(:buc)  { %i[0 1 1 1 0 1 1 1] }
      let(:nbuc) { %i[1 0 0 0 1 0 0 0] }

      let(:f_anb)      { Function[Puts[a, b], Puts[anb]]       }
      let(:f_buc)      { Function[Puts[b, c], Puts[buc]]       }
      let(:f_nbuc)     { Function[Puts[b, c], Puts[nbuc]]      }
      let(:f_ncub)     { Function[Puts[c, b], Puts[nbuc]]      }
      let(:f_buc_nbuc) { Function[Puts[b, c], Puts[buc, nbuc]] }

      it 'merges passed Functions according to their inputs' do
        functions = [f_anb, f_buc, f_nbuc]
        _(FunctionMerger.merge(functions)).must_equal [f_anb, f_buc_nbuc]
      end

      it 'optimises the merged functions' do
        functions = [f_anb, f_buc, f_nbuc, f_buc]
        _(FunctionMerger.merge(functions)).must_equal [f_anb, f_buc_nbuc]
      end

      it 'doesn’t discriminate by input order' do
        functions = [f_anb, f_buc, f_ncub]
        _(FunctionMerger.merge(functions)).must_equal [f_anb, f_buc_nbuc]
      end
    end
  end
end
