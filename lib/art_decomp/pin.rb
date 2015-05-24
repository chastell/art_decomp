require 'anima'

module ArtDecomp
  class Pin
    include Anima.new(:object, :group, :index, :binwidth)

    def self.[](object, group, index, binwidth)
      new(object: object, group: group, index: index, binwidth: binwidth)
    end

    def inspect
      "#{self.class}" \
      "[#{object.inspect}, #{group.inspect}, #{index}, #{binwidth}]"
    end
  end
end
