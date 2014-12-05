require 'delegate'

module ArtDecomp
  class PinPresenter < SimpleDelegator
    def labels
      Array.new(object.binwidths(group)[index]) { |n| label_for(n) }
    end

    private

    def label_for(n)
      bin = object.binwidths(group)[0...index].reduce(0, :+) + n
      "#{group}(#{bin})"
    end
  end
end
