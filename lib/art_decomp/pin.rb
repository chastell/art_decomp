require 'anima'

module ArtDecomp
  class Pin
    include Anima.new(:object, :group, :index, :binwidth, :offset)

    def self.[](object, group, index, binwidth, offset)
      new(object: object, group: group, index: index, binwidth: binwidth,
          offset: offset)
    end

    def inspect
      "#{self.class}" \
      "[#{object}, #{group.inspect}, #{index}, #{binwidth}, #{offset}]"
    end
  end
end
