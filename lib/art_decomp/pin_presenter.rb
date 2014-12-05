require 'delegate'

module ArtDecomp
  class PinPresenter < SimpleDelegator
    def labels
      Array.new(object.binwidths(group)[index]) do |n|
        bin = object.binwidths(group)[0...index].reduce(0, :+) + n
        "#{group}(#{bin})"
      end
    end
  end
end
