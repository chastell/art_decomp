require 'anima'

module ArtDecomp
  class Pin
    include Anima.new(:object, :group, :index)

    def self.[](object, group, index)
      new(object: object, group: group, index: index)
    end

    def inspect
      "#{self.class}[#{object.inspect}, #{group.inspect}, #{index}]"
    end
  end
end
