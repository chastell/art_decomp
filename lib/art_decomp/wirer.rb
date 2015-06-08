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
      [function, :ins, function.ins, put]
    end

    def in_src(put)
      [:circuit, :ins, ins, put]
    end

    def outs_array
      (function.outs & outs).map { |put| [out_src(put), out_dst(put)] }
    end

    def out_dst(put)
      [:circuit, :outs, outs, put]
    end

    def out_src(put)
      [function, :outs, function.outs, put]
    end
  end
end
