require_relative '../../spec_helper'

module ArtDecomp describe FunctionDecomposer::Parallel do
  describe '#decompose' do
    it 'yields decomposed Circuits' do
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
      fun  = Function.new Puts.new is: [a, b, c], os: [anb, buc, nbuc]
      f1   = Function.new Puts.new is: [a, b], os: [anb]
      f2   = Function.new Puts.new is: [b, c], os: [buc]
      f3   = Function.new Puts.new is: [b, c], os: [nbuc]
      f23  = Function.new Puts.new is: [b, c], os: [buc, nbuc]
      fs   = fake :function_simplifier, as: :class
      fm   = fake :function_merger
      stub(fs).simplify(Function.new(Puts.new is: [a,b,c], os: [anb]))  { f1 }
      stub(fs).simplify(Function.new(Puts.new is: [a,b,c], os: [buc]))  { f2 }
      stub(fs).simplify(Function.new(Puts.new is: [a,b,c], os: [nbuc])) { f3 }
      stub(fm).merge([f1, f2, f3]) { [f1, f23] }
      puts = Puts.new is: [a, b, c], os: [anb, buc, nbuc]
      circuit = Circuit.new functions: [f1, f23], puts: puts
      circuit.wires = [
          Wire[Pin[circuit, :is, 0], Pin[f1, :is, 0]],
          Wire[Pin[circuit, :is, 1], Pin[f1, :is, 1]],
          Wire[Pin[f1, :os, 0], Pin[circuit, :os, 0]],
          Wire[Pin[circuit, :is, 1], Pin[f23, :is, 0]],
          Wire[Pin[circuit, :is, 2], Pin[f23, :is, 1]],
          Wire[Pin[f23, :os, 0], Pin[circuit, :os, 1]],
          Wire[Pin[f23, :os, 1], Pin[circuit, :os, 2]],
      ]
      fdp  = FunctionDecomposer::Parallel.new function_merger: fm,
        function_simplifier: fs
      decs = fdp.decompose fun
      decs.to_a.must_equal [circuit]
    end

    it 'does not yield if it can’t decompose' do
      is   = [fake(:put)]
      os   = [fake(:put)]
      fun  = fake :function, is: is, os: os, puts: Puts.new(is: is, os: os)
      fs   = fake :function_simplifier, as: :class
      fm   = fake :function_merger, merge: [fun]
      fdp  = FunctionDecomposer::Parallel.new function_merger: fm,
        function_simplifier: fs
      decs = fdp.decompose fun
      decs.to_a.must_be_empty
    end
  end
end end
