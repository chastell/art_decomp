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
        next unless ins.include?(put)
        index = ins.index(put)
        binwidth = put.binwidth
        source = if put.state?
                   [:circuit, :states, 0, binwidth, 0]
                 else
                   [:circuit, :ins, index, binwidth, ins[0...index].binwidth]
                 end
        [source, [function, :ins, n, binwidth, function.ins[0...n].binwidth]]
      end.compact
    end

    def outs_array                             # rubocop:disable Metrics/AbcSize
      function.outs.map.with_index do |put, n|
        next unless outs.include?(put)
        index = outs.index(put)
        binwidth = put.binwidth
        target = if put.state?
                   [:circuit, :next_states, 0, binwidth, 0]
                 else
                   [:circuit, :outs, index, binwidth, outs[0...index].binwidth]
                 end
        [[function, :outs, n, binwidth, function.outs[0...n].binwidth], target]
      end.compact
    end
  end
end
