require_relative '../spec_helper'

module ArtDecomp describe FunctionSimplifier do
  describe '#simplify' do
    it 'returns the simplest implementation of a Function' do
      #   | a b c | anb buc
      # --+-------+--------
      # 0 | 0 0 0 |  0   0
      # 1 | 0 0 1 |  0   1
      # 2 | 0 1 0 |  0   1
      # 3 | 0 1 1 |  0   1
      # 4 | 1 0 0 |  0   0
      # 5 | 1 0 1 |  0   1
      # 6 | 1 1 0 |  1   1
      # 7 | 1 1 1 |  1   1
      a    = Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]]
      b    = Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]]
      c    = Put[:'0' => B[0,2,4,6], :'1' => B[1,3,5,7]]
      anb  = Put[:'0' => B[0,1,2,3,4,5], :'1' => B[6,7]]
      buc  = Put[:'0' => B[0,4], :'1' => B[1,2,3,5,6,7]]
      fanb = Function.new [a, b, c], [anb]
      fbuc = Function.new [a, b, c], [buc]
      fs   = FunctionSimplifier.new
      fs.simplify(fanb).must_equal Function.new([a,b], [anb])
      fs.simplify(fbuc).must_equal Function.new([c,b], [buc])
    end
  end
end end
