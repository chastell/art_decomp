require_relative 'wires'

module ArtDecomp
  class Wirer
    def initialize(function, ins:, outs:)
      @function, @ins, @outs = function, ins, outs
    end

    def wires
      ins_wires + outs_wires
    end

    private

    private_attr_reader :function, :ins, :outs

    def ins_wires
      Wires.from_array(ins.map.with_index do |put, n|
        offset = ins[0...n].map(&:binwidth).reduce(0, :+)
        source = if put.state?
                   [:circuit, :states, 0, put.binwidth, 0]
                 else
                   [:circuit, :ins, n, put.binwidth, offset]
                 end
        [source, [function, :ins, n, put.binwidth, offset]]
      end.compact)
    end

    def outs_wires
      Wires.from_array(outs.map.with_index do |put, n|
        offset = outs[0...n].map(&:binwidth).reduce(0, :+)
        target = if put.state?
                   [:circuit, :next_states, 0, put.binwidth, 0]
                 else
                   [:circuit, :outs, n, put.binwidth, offset]
                 end
        [[function, :outs, n, put.binwidth, offset], target]
      end.compact)
    end
  end
end
