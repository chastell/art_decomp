require_relative '../spec_helper'

module ArtDecomp describe CircuitPresenter do
  describe '#vhdl' do
    it 'returns VHDL for the given Circuit' do
      function = double widths: -> s { { i: [1,1,1,2], o: [1,1,1,1,1,2]}[s] }
      circuit  = double functions: [function], recoders: [],
        widths: -> s { { i: [1,1,1], o: [1,1,1,1,1], q: [2], p: [2] }[s] }
      circuit.wirings = {
           Pin.new(function, :i, 0) => Pin.new(circuit, :i, 0),
           Pin.new(function, :i, 1) => Pin.new(circuit, :i, 1),
           Pin.new(function, :i, 2) => Pin.new(circuit, :i, 2),
           Pin.new(function, :i, 3) => Pin.new(circuit, :q, 0),
           Pin.new(circuit, :o, 0) => Pin.new(function, :o, 0),
           Pin.new(circuit, :o, 1) => Pin.new(function, :o, 1),
           Pin.new(circuit, :o, 2) => Pin.new(function, :o, 2),
           Pin.new(circuit, :o, 3) => Pin.new(function, :o, 3),
           Pin.new(circuit, :o, 4) => Pin.new(function, :o, 4),
           Pin.new(circuit, :p, 0) => Pin.new(function, :o, 5),
        }

      function_presenter = double widths: -> s { { i: [1,1,1,2], o: [1,1,1,1,1,2]}[s] }, rows: [
          ['0--10', '0001010'],
          ['-0-10', '0001010'],
          ['11-10', '1001011'],
          ['--011', '0011011'],
          ['--111', '1011000'],
          ['10-00', '0100000'],
          ['0--00', '1100001'],
          ['-1-00', '1100001'],
          ['--001', '0100101'],
          ['--101', '1100110'],
        ]
      fp_factory = double new: -> _ { function_presenter }

      cp = CircuitPresenter.new circuit, fp_factory: fp_factory

      cp.vhdl('mc').must_equal File.read 'spec/fixtures/mc.vhdl'
    end

    it 'returns VHDL for the given decomposed Circuit' do
      f0 = double widths: -> s { { i: [1,1,1], o: [1,1] }[s] }
      f1 = double widths: -> s { { i: [1,1,1,1], o: [1,1,1,1,1,1,1] }[s] }
      r0 = double widths: -> s { { i: [2], o: [1,1] }[s] }
      r1 = double widths: -> s { { i: [1,1], o: [2] }[s] }
      circuit = double functions: [f0, f1], recoders: [r0, r1],
        widths: -> s { { i: [1,1,1], o: [1,1,1,1,1], q: [2], p: [2] }[s] }
      circuit.wirings = {
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

      fp0 = double widths: -> s { { i: [1,1,1], o: [1,1] }[s] }, rows: [
          ['000', '10'],
          ['001', '01'],
          ['010', '10'],
          ['011', '01'],
          ['100', '00'],
          ['101', '01'],
          ['110', '10'],
          ['111', '11'],
        ]

      fp1 = double widths: -> s { { i: [1,1,1,1], o: [1,1,1,1,1,1,1] }[s] }, rows: [
          ['-000', '0001000'],
          ['-010', '0100010'],
          ['-100', '1011000'],
          ['-110', '1110010'],
          ['0001', '1001001'],
          ['0011', '1100110'],
          ['0101', '1001001'],
          ['0111', '1100110'],
          ['1001', '0111001'],
          ['1011', '0010110'],
          ['1101', '0111001'],
          ['1111', '0010110'],
        ]
      fp_factory = double new: -> f { { f0 => fp0, f1 => fp1 }[f] }

      cp = CircuitPresenter.new circuit, fp_factory: fp_factory

      cp.vhdl('mc').must_equal File.read 'spec/fixtures/mc.decomposed.vhdl'
    end
  end
end end
