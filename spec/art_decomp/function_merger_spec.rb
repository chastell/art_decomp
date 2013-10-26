require_relative '../spec_helper'

module ArtDecomp describe FunctionMerger do
  describe '#merge' do
    it 'merges passed Functions according to their inputs' do
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
      a    = Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]]
      b    = Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]]
      c    = Put[:'0' => B[0,2,4,6], :'1' => B[1,3,5,7]]
      anb  = Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]]
      buc  = Put[:'0' => B[0,4], :'1' => B[1,2,3,5,6,7]]
      nbuc = Put[:'0' => B[1,2,3,5,6,7], :'1' => B[0,4]]
      f1   = Function.new Puts.new is: [a, b], os: [anb]
      f2   = Function.new Puts.new is: [b, c], os: [buc]
      f3   = Function.new Puts.new is: [b, c], os: [nbuc]
      f23  = Function.new Puts.new is: [b, c], os: [buc, nbuc]
      FunctionMerger.new.merge([f1, f2, f3]).must_equal [f1, f23]
    end
  end
end end
