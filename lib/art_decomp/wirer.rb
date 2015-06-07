require_relative 'wires'

module ArtDecomp
  class Wirer
    def self.wires(function, ins:, outs:)
      new(function, ins: ins, outs: outs).wires
    end

    def initialize(function, ins:, outs:)
      @function, @ins, @outs = function, ins, outs
    end

    def wires
      Wires.from_array(ins_array) + Wires.from_array(outs_array)
    end

    private

    private_attr_reader :function, :ins, :outs

    def ins_array
      (function.ins & ins).map { |put| [in_src(put), in_dst(put)] }
    end

    def in_dst(put)
      index = function.ins.index(put)
      [function, :ins, index, put.binwidth, function.ins[0...index].binwidth]
    end

    def in_src(put)
      if put.state?
        [:circuit, :states, 0, put.binwidth, 0]
      else
        offset = ins[0...ins.index(put)].binwidth
        [:circuit, :ins, ins.index(put), put.binwidth, offset]
      end
    end

    def outs_array
      (function.outs & outs).map { |put| [out_src(put), out_dst(put)] }
    end

    def out_dst(put)
      if put.state?
        [:circuit, :next_states, 0, put.binwidth, 0]
      else
        offset = outs[0...outs.index(put)].binwidth
        [:circuit, :outs, outs.index(put), put.binwidth, offset]
      end
    end

    def out_src(put)
      index = function.outs.index(put)
      [function, :outs, index, put.binwidth, function.outs[0...index].binwidth]
    end
  end
end
