require_relative 'wires'

module ArtDecomp
  class Wirer
    def self.wires(function, own:)
      new(function, own: own).wires
    end

    def initialize(function, own:)
      @function, @own = function, own
    end

    def wires
      Wires.from_array(ins_array) + Wires.from_array(outs_array)
    end

    private

    attr_reader :function, :own

    def ins_array
      (function.ins & own.ins).map do |put|
        [[:circuit, own.ins, put], [function, function.ins, put]]
      end
    end

    def outs_array
      (function.outs & own.outs).map do |put|
        [[function, function.outs, put], [:circuit, own.outs, put]]
      end
    end
  end
end
