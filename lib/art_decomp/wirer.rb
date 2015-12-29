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

    attr_reader :function, :ins, :outs

    # :reek:DuplicateMethodCall { max_calls: 2 }
    def ins_array
      (function.ins & ins).map do |put|
        [[:circuit, ins, put], [function, function.ins, put]]
      end
    end

    # :reek:DuplicateMethodCall { max_calls: 2 }
    def outs_array
      (function.outs & outs).map do |put|
        [[function, function.outs, put], [:circuit, outs, put]]
      end
    end
  end
end
