require_relative '../../spec_helper'
require_relative '../../../lib/art_decomp/b'
require_relative '../../../lib/art_decomp/circuit'
require_relative '../../../lib/art_decomp/function'
require_relative '../../../lib/art_decomp/function_decomposer/parallel'
require_relative '../../../lib/art_decomp/pin'
require_relative '../../../lib/art_decomp/put'
require_relative '../../../lib/art_decomp/puts_set'
require_relative '../../../lib/art_decomp/wire'

module ArtDecomp
  describe FunctionDecomposer::Parallel do
    describe '.decompose' do
      #   | a b c | anb buc nbuc
      # --+-------+-------------
      # 0 | 0 0 0 |  0   0   1
      # 1 | 0 0 1 |  0   1   0
      # 2 | 0 1 0 |  0   1   0
      # 3 | 0 1 1 |  0   1   0
      # 4 | 1 0 0 |  0   0   1
      # 5 | 1 0 1 |  0   1   0
      # 6 | 1 1 0 |  1   1   0
      # 7 | 1 1 1 |  1   1   0

      it 'yields decomposed Circuits' do
        a    = Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]]
        b    = Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]]
        c    = Put[:'0' => B[0,2,4,6], :'1' => B[1,3,5,7]]
        anb  = Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]]
        buc  = Put[:'0' => B[0,4], :'1' => B[1,2,3,5,6,7]]
        nbuc = Put[:'0' => B[1,2,3,5,6,7], :'1' => B[0,4]]
        ab_anb      = Function.new(PutsSet.new(is: [a,b], os: [anb]))
        bc_buc_nbuc = Function.new(PutsSet.new(is: [b,c], os: [buc, nbuc]))
        puts_set = PutsSet.new(is: [a, b, c], os: [anb, buc, nbuc])
        circuit  = Circuit.new(functions: [ab_anb, bc_buc_nbuc],
                               puts_set: puts_set)
        circuit.wires.replace [
          Wire[Pin[circuit, :is, 0], Pin[ab_anb, :is, 0]],
          Wire[Pin[circuit, :is, 1], Pin[ab_anb, :is, 1]],
          Wire[Pin[ab_anb, :os, 0], Pin[circuit, :os, 0]],
          Wire[Pin[circuit, :is, 1], Pin[bc_buc_nbuc, :is, 0]],
          Wire[Pin[circuit, :is, 2], Pin[bc_buc_nbuc, :is, 1]],
          Wire[Pin[bc_buc_nbuc, :os, 0], Pin[circuit, :os, 1]],
          Wire[Pin[bc_buc_nbuc, :os, 1], Pin[circuit, :os, 2]],
        ]
        fun = Function.new(puts_set)
        FunctionDecomposer::Parallel.decompose(fun).to_a.must_equal [circuit]
      end

      it 'does not yield if it can’t decompose' do
        a   = Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]]
        b   = Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]]
        anb = Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]]
        fun = Function.new(PutsSet.new(is: [a, b], os: [anb]))
        FunctionDecomposer::Parallel.decompose(fun).to_a.must_be_empty
      end
    end
  end
end
