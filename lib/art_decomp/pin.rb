require 'anima'

module ArtDecomp
  class Pin
    include Anima.new(:object, :group, :puts, :put)

    # :reek:LongParameterList: { max_params: 4 }
    def self.[](object, group, puts, put)
      new(object: object, group: group, puts: puts, put: put)
    end

    def binwidth
      put.binwidth
    end

    def index
      puts.index(put)
    end

    def inspect
      "#{self.class}" \
      "[#{object.inspect}, #{group.inspect}, #{index}, #{binwidth}, #{offset}]"
    end

    def offset
      puts[0...index].binwidth
    end
  end
end
