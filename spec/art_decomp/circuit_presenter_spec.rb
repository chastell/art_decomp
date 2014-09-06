require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/circuit_presenter'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/pin'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/wire'

module ArtDecomp
  describe CircuitPresenter do
    describe '.vhdl_for' do
      it 'returns VHDL for the given Circuit' do
        stub(cp = fake(:circuit_presenter)).vhdl('name') { 'VHDL' }
        CircuitPresenter.vhdl_for(fake(:circuit), 'name', circuit_presenter: cp)
          .must_equal 'VHDL'
      end
    end

    describe '#vhdl' do
      let(:circuit) do
        KISSParser.circuit_for(File.read('spec/fixtures/mc.kiss'))
      end

      let(:circuit_presenter) { CircuitPresenter.new(circuit) }

      it 'returns VHDL for the given Circuit' do
        circuit_presenter.vhdl('mc')
          .must_equal File.read('spec/fixtures/mc.vhdl')
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
        f0 = Function.new(Puts.new(is: f0is, os: f0os))
        f1 = Function.new(Puts.new(is: f1is, os: f1os))
        r_state = [Put[FG: B[0], FY: B[1], HG: B[2], HY: B[3]]]
        r_coded = [Put[a: B[0,2], b: B[1,3]], Put[a: B[0,1], b: B[2,3]]]
        r0 = Function.new(Puts.new(is: r_state, os: r_coded))
        r1 = Function.new(Puts.new(is: r_coded, os: r_state))
        circuit.functions.replace [f0, f1]
        circuit.recoders.replace  [r0, r1]
        circuit.wires.replace [
          Wire[Pin[circuit, :is, 0], Pin[f0, :is, 0]],
          Wire[Pin[circuit, :is, 1], Pin[f0, :is, 1]],
          Wire[Pin[r0, :os, 1], Pin[f0, :is, 2]],
          Wire[Pin[circuit, :is, 2], Pin[f1, :is, 0]],
          Wire[Pin[f0, :os, 0], Pin[f1, :is, 1]],
          Wire[Pin[f0, :os, 1], Pin[f1, :is, 2]],
          Wire[Pin[r0, :os, 0], Pin[f1, :is, 3]],
          Wire[Pin[r1, :os, 0], Pin[circuit, :ps, 0]],
          Wire[Pin[f1, :os, 2], Pin[circuit, :os, 0]],
          Wire[Pin[f1, :os, 3], Pin[circuit, :os, 1]],
          Wire[Pin[f1, :os, 4], Pin[circuit, :os, 2]],
          Wire[Pin[f1, :os, 5], Pin[circuit, :os, 3]],
          Wire[Pin[f1, :os, 6], Pin[circuit, :os, 4]],
        ]

        vhdl = File.read('spec/fixtures/mc.decomposed.vhdl')
        circuit_presenter.vhdl('mc').must_equal vhdl
      end
    end
  end
end
