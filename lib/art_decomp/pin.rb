require 'anima'

module ArtDecomp
  class Pin
    include Anima.new(:object, :group, :puts, :put, :index, :binwidth, :offset)

    def self.[](object, group, puts, put, index, binwidth, offset)
      new(object: object, group: group, puts: puts, put: put, index: index,
          binwidth: binwidth, offset: offset)
    end

    def inspect
      "#{self.class}" \
      "[#{object.inspect}, #{group.inspect}, #{index}, #{binwidth}, #{offset}]"
    end
  end
end
