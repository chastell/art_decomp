require_relative 'wires'

module ArtDecomp
  class Wirer
    def initialize(function, ins:, outs:)
      @function, @ins, @outs = function, ins, outs
    end

    def wires
      Wires.from_array(ins_array) + Wires.from_array(outs_array)
    end

    private

    private_attr_reader :function, :ins, :outs

    def ins_array
      function.ins.map.with_index do |put, n|
        next unless ins.include?(put)
        [ins_source(ins, put), ins_destination(function, put, n)]
      end.compact
    end

    def ins_destination(function, put, n)
      [function, :ins, n, put.binwidth, function.ins[0...n].binwidth]
    end

    def ins_source(ins, put)
      if put.state?
        [:circuit, :states, 0, put.binwidth, 0]
      else
        offset = ins[0...ins.index(put)].binwidth
        [:circuit, :ins, ins.index(put), put.binwidth, offset]
      end
    end

    def outs_array
      function.outs.map.with_index do |put, n|
        next unless outs.include?(put)
        [outs_source(function, put, n), outs_destination(outs, put)]
      end.compact
    end

    def outs_destination(outs, put)
      if put.state?
        [:circuit, :next_states, 0, put.binwidth, 0]
      else
        offset = outs[0...outs.index(put)].binwidth
        [:circuit, :outs, outs.index(put), put.binwidth, offset]
      end
    end

    def outs_source(function, put, n)
      [function, :outs, n, put.binwidth, function.outs[0...n].binwidth]
    end
  end
end
