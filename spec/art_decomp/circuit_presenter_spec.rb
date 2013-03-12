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

  describe '#vhdl' do
    let(:circuit) { KISSParser.new(File.read 'spec/fixtures/mc.kiss').circuit }
    let(:circuit_presenter) { CircuitPresenter.new circuit }

    it 'returns VHDL for the given Circuit' do
      circuit_presenter.vhdl('mc').must_equal File.read 'spec/fixtures/mc.vhdl'
    end

    it 'returns VHDL for the given decomposed Circuit' do
      f0is = [
        { :'0' => [0,1,2,3], :'1' => [4,5,6,7] },
        { :'0' => [0,1,4,5], :'1' => [2,3,6,7] },
        { a: [0,2,4,6], b: [1,3,5,7] },
      ]
      f0os = [
        { a: [1,3,4,5], b: [0,2,6,7] },
        { a: [0,2,4,6], b: [1,3,5,7] },
      ]
      f1is = [
        { :'0' => [0,1,2,3,4,5,6,7], :'1' => [0,1,2,3,8,9,10,11] },
        { a: [0,1,4,5,8,9], b: [2,3,6,7,10,11] },
        { a: [0,2,4,6,8,10], b: [1,3,5,7,9,11] },
        { a: [0,1,2,3], b: [4,5,6,7,8,9,10,11] },
      ]
      f1os = [
        { a: [0,1,8,9,10,11], b: [2,3,4,5,6,7] },
        { a: [0,2,4,6,9,11], b: [1,3,5,7,8,10] },
        { :'0' => [0,1,4,5,6,7], :'1' => [2,3,8,9,10,11] },
        { :'0' => [1,3,5,7,9,11], :'1' => [0,2,4,6,8,10] },
        { :'0' => [0,1,2,3,4,6,8,10], :'1' => [5,7,9,11] },
        { :'0' => [0,2,4,6,8,10], :'1' => [1,3,5,7,9,11] },
        { :'0' => [0,1,2,3,5,7,9,11], :'1' => [4,6,8,10] },
      ]
      f0 = Function.new f0is, f0os
      f1 = Function.new f1is, f1os
      r_state = [{ FG: [0], FY: [1], HG: [2], HY: [3] }]
      r_coded = [{ a: [0,2], b: [1,3] }, { a: [0,1], b: [2,3] }]
      r0 = Function.new r_state, r_coded
      r1 = Function.new r_coded, r_state
      circuit.functions = [f0, f1]
      circuit.recoders  = [r0, r1]
      circuit.wirings   = {
        Pin.new(f0, :i, 0) => Pin.new(circuit, :i, 0),
        Pin.new(f0, :i, 1) => Pin.new(circuit, :i, 1),
        Pin.new(f0, :i, 2) => Pin.new(r0, :o, 1),
        Pin.new(f1, :i, 0) => Pin.new(circuit, :i, 2),
        Pin.new(f1, :i, 1) => Pin.new(f0, :o, 0),
        Pin.new(f1, :i, 2) => Pin.new(f0, :o, 1),
        Pin.new(f1, :i, 3) => Pin.new(r0, :o, 0),
        Pin.new(circuit, :p, 0) => Pin.new(r1, :o, 0),
        Pin.new(circuit, :o, 0) => Pin.new(f1, :o, 2),
        Pin.new(circuit, :o, 1) => Pin.new(f1, :o, 3),
        Pin.new(circuit, :o, 2) => Pin.new(f1, :o, 4),
        Pin.new(circuit, :o, 3) => Pin.new(f1, :o, 5),
        Pin.new(circuit, :o, 4) => Pin.new(f1, :o, 6),
      }

      circuit_presenter.vhdl('mc').must_equal File.read 'spec/fixtures/mc.decomposed.vhdl'
    end
  end
end end
