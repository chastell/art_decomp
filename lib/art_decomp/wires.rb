module ArtDecomp
  class Wires
    def self.from_function(function)
      in_wires  = function.ins.map  { |put| { put => put } }
      out_wires = function.outs.map { |put| { put => put } }
      (in_wires + out_wires).reduce({}, :merge)
    end
  end
end
