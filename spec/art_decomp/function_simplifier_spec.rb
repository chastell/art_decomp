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
      a = fake :put, seps: [
        B[0,4], B[0,5], B[0,6], B[0,7],
        B[1,4], B[1,5], B[1,6], B[1,7],
        B[2,4], B[2,5], B[2,6], B[2,7],
        B[3,4], B[3,5], B[3,6], B[3,7],
      ]
      b = fake :put, seps: [
        B[0,2], B[0,3], B[0,6], B[0,7],
        B[1,2], B[1,3], B[1,6], B[1,7],
        B[4,2], B[4,3], B[4,6], B[4,7],
        B[5,2], B[5,3], B[5,6], B[5,7],
      ]
      c = fake :put, seps: [
        B[0,1], B[0,3], B[0,5], B[0,7],
        B[2,1], B[2,3], B[2,5], B[2,7],
        B[4,1], B[4,3], B[4,5], B[4,7],
        B[6,1], B[6,3], B[6,5], B[6,7],
      ]
      anb = fake :put, seps: [
        B[0,6], B[0,7],
        B[1,6], B[1,7],
        B[2,6], B[2,7],
        B[3,6], B[3,7],
        B[4,6], B[4,7],
        B[5,6], B[5,7],
      ]
      buc = fake :put, seps: [
        B[0,1], B[0,2], B[0,3], B[0,5], B[0,6], B[0,7],
        B[4,1], B[4,2], B[4,3], B[4,5], B[4,6], B[4,7],
      ]
      fanb = Function.new [a, b, c], [anb]
      fbuc = Function.new [a, b, c], [buc]
      fs   = FunctionSimplifier.new
      fs.simplify(fanb).must_equal Function.new([a,b], [anb])
      fs.simplify(fbuc).must_equal Function.new([c,b], [buc])
    end
  end
end end
