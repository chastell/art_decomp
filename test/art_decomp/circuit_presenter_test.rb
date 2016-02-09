# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/art_decomp/circuit_presenter'
require_relative '../../lib/art_decomp/fsm_kiss_parser'
require_relative '../../lib/art_decomp/kiss_parser'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/recoder'
require_relative '../../lib/art_decomp/wires'

module ArtDecomp # rubocop:disable Metrics/ModuleLength
  describe CircuitPresenter do
    describe '.vhdl_for' do
      let(:bin) do
        KISSParser.circuit_for(File.read('test/fixtures/bin.kiss'))
      end

      let(:mc) do
        FSMKISSParser.circuit_for(File.read('test/fixtures/mc.kiss'))
      end

      let(:mc_decd) do
        f0 = KISSParser.function_for <<-end
          00a ba
          00b ab
          01a ba
          01b ab
          10a aa
          10b ab
          11a ba
          11b bb
        end
        f1 = KISSParser.function_for <<-end
          -aaa aa01000
          -aba ab00010
          -baa ba11000
          -bba bb10010
          0aab ba01001
          0abb bb00110
          0bab ba01001
          0bbb bb00110
          1aab ab11001
          1abb aa10110
          1bab ab11001
          1bbb aa10110
        end
        r_state = Puts[%i(FG FY HG HY)]
        r_coded = Puts[%i(a b a b), %i(a a b b)]
        r0 = Recoder.new(ins: r_state, outs: r_coded)
        r1 = Recoder.new(ins: r_coded, outs: r_state)
        wires = Wires.new(
          f0.ins[0]      => mc.own.ins[0],
          f0.ins[1]      => mc.own.ins[1],
          r0.ins[0]      => mc.own.ins[3],
          f0.ins[2]      => r0.outs[1],
          f1.ins[0]      => mc.own.ins[2],
          f1.ins[1]      => f0.outs[0],
          f1.ins[2]      => f0.outs[1],
          f1.ins[3]      => r0.outs[0],
          mc.own.outs[5] => r1.outs[0],
          r1.ins[0]      => f1.outs[0],
          r1.ins[1]      => f1.outs[1],
          mc.own.outs[0] => f1.outs[2],
          mc.own.outs[1] => f1.outs[3],
          mc.own.outs[2] => f1.outs[4],
          mc.own.outs[3] => f1.outs[5],
          mc.own.outs[4] => f1.outs[6],
        )
        mc.with(functions: [f0, f1, r0, r1], wires: wires)
      end

      it 'returns VHDL for the given Circuit' do
        vhdl = CircuitPresenter.vhdl_for(bin, name: 'bin')
        _(vhdl).must_equal File.read('test/fixtures/bin.vhdl')
      end

      it 'returns VHDL for the given decomposed Circuit' do
        f0 = KISSParser.function_for <<-end
          01- 0
          0-0 0
          000 0
          011 0
          11- 0
          110 0
          001 1
          10- 1
        end
        f1 = KISSParser.function_for <<-end
          0100 0
          0100 0
          -1-0 0
          01-0 0
          001- 0
          --10 0
          1--0 0
          000- 1
          -1-1 1
          1--1 1
        end
        wires = Wires.new(
          f0.ins[0]       => bin.own.ins[2],
          f0.ins[1]       => bin.own.ins[3],
          f0.ins[2]       => bin.own.ins[4],
          f1.ins[0]       => bin.own.ins[0],
          f1.ins[1]       => bin.own.ins[1],
          f1.ins[2]       => bin.own.ins[5],
          f1.ins[3]       => f0.outs[0],
          bin.own.outs[0] => f1.outs[0],
        )
        bin_decd = bin.with(functions: [f0, f1], wires: wires)
        vhdl = CircuitPresenter.vhdl_for(bin_decd, name: 'bin')
        _(vhdl).must_equal File.read('test/fixtures/bin.decomposed.vhdl')
      end

      it 'returns VHDL for the given FSM' do
        vhdl = CircuitPresenter.vhdl_for(mc, name: 'mc')
        _(vhdl).must_equal File.read('test/fixtures/mc.vhdl')
      end

      it 'returns VHDL for the given decomposed FSM' do
        vhdl = CircuitPresenter.vhdl_for(mc_decd, name: 'mc')
        _(vhdl).must_equal File.read('test/fixtures/mc.decomposed.vhdl')
      end
    end
  end
end
