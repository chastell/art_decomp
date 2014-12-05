require 'delegate'

module ArtDecomp
  class PinPresenter < SimpleDelegator
    def wirings
      Array.new(object.binwidths(group)[index]) { |n| wiring_for(n) }
    end

    private

    def wiring_for(n)
      bin = object.binwidths(group)[0...index].reduce(0, :+) + n
      "#{group}(#{bin})"
    end
  end
end
