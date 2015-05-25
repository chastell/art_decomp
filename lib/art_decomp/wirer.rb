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

    def ins_array                              # rubocop:disable Metrics/AbcSize
      function.ins.map.with_index do |put, n|
        c_offset = ins[0...ins.index(put)].map(&:binwidth).reduce(0, :+)
        f_offset = function.ins[0...n].map(&:binwidth).reduce(0, :+)
        source = if put.state?
                   [:circuit, :states, 0, put.binwidth, 0]
                 else
                   [:circuit, :ins, ins.index(put), put.binwidth, c_offset]
                 end
        [source, [function, :ins, n, put.binwidth, f_offset]]
      end.compact
    end

    def outs_array                             # rubocop:disable Metrics/AbcSize
      function.outs.map.with_index do |put, n|
        c_offset = outs[0...outs.index(put)].map(&:binwidth).reduce(0, :+)
        f_offset = function.outs[0...n].map(&:binwidth).reduce(0, :+)
        target = if put.state?
                   [:circuit, :next_states, 0, put.binwidth, 0]
                 else
                   [:circuit, :outs, outs.index(put), put.binwidth, c_offset]
                 end
        [[function, :outs, n, put.binwidth, f_offset], target]
      end.compact
    end
  end
end
