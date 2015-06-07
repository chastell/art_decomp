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
      function.ins.map do |put|
        next unless ins.include?(put)
        [ins_source(ins, put), ins_destination(function, put)]
      end.compact
    end

    def ins_destination(function, put)
      index = function.ins.index(put)
      [function, :ins, index, put.binwidth, function.ins[0...index].binwidth]
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
      function.outs.map do |put|
        next unless outs.include?(put)
        [outs_source(function, put), outs_destination(outs, put)]
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

    def outs_source(function, put)
      index = function.outs.index(put)
      [function, :outs, index, put.binwidth, function.outs[0...index].binwidth]
    end
  end
end
