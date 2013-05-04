require_relative '../spec_helper'

module ArtDecomp describe CircuitPresenter do
  describe '.vhdl_for_circuit' do
    it 'returns VHDL for the given circuit' do
      circuit_presenter = MiniTest::Mock.new.expect :vhdl, 'VHDL', ['name']
      CircuitPresenter.stub :new, circuit_presenter do
        CircuitPresenter.vhdl_for_circuit(double, 'name').must_equal 'VHDL'
      end
      circuit_presenter.verify
    end
  end

  describe '#puts' do
    it 'returns the types of Put groups it responds to' do
      CircuitPresenter.new(Circuit.new).puts.must_equal [:is, :os, :ps, :qs]
    end
  end

  describe '#vhdl' do
    let(:circuit) { KISSParser.new(File.read 'spec/fixtures/mc.kiss').circuit }
    let(:circuit_presenter) { CircuitPresenter.new circuit }

    it 'returns VHDL for the given Circuit' do
      circuit_presenter.vhdl('mc').must_equal File.read 'spec/fixtures/mc.vhdl'
    end

    it 'returns VHDL for the given decomposed Circuit' do
      f0is = [
        Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]],
        Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]],
        Put[a: B[0,2,4,6], b: B[1,3,5,7]],
      ]
      f0os = [
        Put[a: B[1,3,4,5], b: B[0,2,6,7]],
        Put[a: B[0,2,4,6], b: B[1,3,5,7]],
      ]
      f1is = [
        Put[:'0' => B[0,1,2,3,4,5,6,7], :'1' => B[0,1,2,3,8,9,10,11]],
        Put[a: B[0,1,4,5,8,9], b: B[2,3,6,7,10,11]],
        Put[a: B[0,2,4,6,8,10], b: B[1,3,5,7,9,11]],
        Put[a: B[0,1,2,3], b: B[4,5,6,7,8,9,10,11]],
      ]
      f1os = [
        Put[a: B[0,1,8,9,10,11], b: B[2,3,4,5,6,7]],
        Put[a: B[0,2,4,6,9,11], b: B[1,3,5,7,8,10]],
        Put[:'0' => B[0,1,4,5,6,7], :'1' => B[2,3,8,9,10,11]],
        Put[:'0' => B[1,3,5,7,9,11], :'1' => B[0,2,4,6,8,10]],
        Put[:'0' => B[0,1,2,3,4,6,8,10], :'1' => B[5,7,9,11]],
        Put[:'0' => B[0,2,4,6,8,10], :'1' => B[1,3,5,7,9,11]],
        Put[:'0' => B[0,1,2,3,5,7,9,11], :'1' => B[4,6,8,10]],
      ]
      f0 = Function.new f0is, f0os
      f1 = Function.new f1is, f1os
      r_state = [Put[FG: B[0], FY: B[1], HG: B[2], HY: B[3]]]
      r_coded = [Put[a: B[0,2], b: B[1,3]], Put[a: B[0,1], b: B[2,3]]]
      r0 = Function.new r_state, r_coded
      r1 = Function.new r_coded, r_state
      circuit.functions = [f0, f1]
      circuit.recoders  = [r0, r1]
      circuit.wires     = [
        Wire.new(circuit.is[0], f0.is[0]),
        Wire.new(circuit.is[1], f0.is[1]),
        Wire.new(r0.os[1], f0.is[2]),
        Wire.new(circuit.is[2], f1.is[0]),
        Wire.new(f0.os[0], f1.is[1]),
        Wire.new(f0.os[1], f1.is[2]),
        Wire.new(r0.os[0], f1.is[3]),
        Wire.new(r1.os[0], circuit.ps[0]),
        Wire.new(f1.os[2], circuit.os[0]),
        Wire.new(f1.os[3], circuit.os[1]),
        Wire.new(f1.os[4], circuit.os[2]),
        Wire.new(f1.os[5], circuit.os[3]),
        Wire.new(f1.os[6], circuit.os[4]),
      ]

      circuit_presenter.vhdl('mc').must_equal File.read 'spec/fixtures/mc.decomposed.vhdl'
    end
  end
end end
