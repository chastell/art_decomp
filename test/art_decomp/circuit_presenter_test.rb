require_relative '../test_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/circuit_presenter'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'

module ArtDecomp
  describe CircuitPresenter do
    describe '.vhdl_for' do
      let(:circuit) do
        KISSParser.circuit_for(File.read('test/fixtures/mc.kiss'))
      end

      it 'returns VHDL for the given Circuit' do
        CircuitPresenter.vhdl_for(circuit, name: 'mc')
          .must_equal File.read('test/fixtures/mc.vhdl')
      end

      it 'returns VHDL for the given decomposed Circuit' do
        f0is = Puts.new([
          Put[:'0' => B[0,1,2,3], :'1' => B[4,5,6,7]],
          Put[:'0' => B[0,1,4,5], :'1' => B[2,3,6,7]],
          Put[a: B[0,2,4,6], b: B[1,3,5,7]],
        ])
        f0os = Puts.new([
          Put[a: B[1,3,4,5], b: B[0,2,6,7]],
          Put[a: B[0,2,4,6], b: B[1,3,5,7]],
        ])
        f1is = Puts.new([
          Put[:'0' => B[0,1,2,3,4,5,6,7], :'1' => B[0,1,2,3,8,9,10,11]],
          Put[a: B[0,1,4,5,8,9], b: B[2,3,6,7,10,11]],
          Put[a: B[0,2,4,6,8,10], b: B[1,3,5,7,9,11]],
          Put[a: B[0,1,2,3], b: B[4,5,6,7,8,9,10,11]],
        ])
        f1os = Puts.new([
          Put[a: B[0,1,8,9,10,11], b: B[2,3,4,5,6,7]],
          Put[a: B[0,2,4,6,9,11], b: B[1,3,5,7,8,10]],
          Put[:'0' => B[0,1,4,5,6,7], :'1' => B[2,3,8,9,10,11]],
          Put[:'0' => B[1,3,5,7,9,11], :'1' => B[0,2,4,6,8,10]],
          Put[:'0' => B[0,1,2,3,4,6,8,10], :'1' => B[5,7,9,11]],
          Put[:'0' => B[0,2,4,6,8,10], :'1' => B[1,3,5,7,9,11]],
          Put[:'0' => B[0,1,2,3,5,7,9,11], :'1' => B[4,6,8,10]],
        ])
        f0 = Function.new(is: f0is, os: f0os)
        f1 = Function.new(is: f1is, os: f1os)
        r_state = Puts.new([Put[FG: B[0], FY: B[1], HG: B[2], HY: B[3]]])
        r_coded = Puts.new([Put[a: B[0,2], b: B[1,3]],
                            Put[a: B[0,1], b: B[2,3]]])
        r0 = Function.new(is: r_state, os: r_coded)
        r1 = Function.new(is: r_coded, os: r_state)
        circuit.functions.replace [f0, f1]
        circuit.recoders.replace  [r0, r1]
        circuit.instance_variable_set :@wires, Wires.from_array([
          [[:circuit, :is, 0], [f0,       :is,          0]],
          [[:circuit, :is, 1], [f0,       :is,          1]],
          [[r0,       :os, 1], [f0,       :is,          2]],
          [[:circuit, :is, 2], [f1,       :is,          0]],
          [[f0,       :os, 0], [f1,       :is,          1]],
          [[f0,       :os, 1], [f1,       :is,          2]],
          [[r0,       :os, 0], [f1,       :is,          3]],
          [[r1,       :os, 0], [:circuit, :next_states, 0]],
          [[f1,       :os, 2], [:circuit, :os,          0]],
          [[f1,       :os, 3], [:circuit, :os,          1]],
          [[f1,       :os, 4], [:circuit, :os,          2]],
          [[f1,       :os, 5], [:circuit, :os,          3]],
          [[f1,       :os, 6], [:circuit, :os,          4]],
        ])

        vhdl = File.read('test/fixtures/mc.decomposed.vhdl')
        CircuitPresenter.vhdl_for(circuit, name: 'mc').must_equal vhdl
      end
    end
  end
end
