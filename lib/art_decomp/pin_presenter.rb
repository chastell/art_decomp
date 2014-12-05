require 'delegate'

module ArtDecomp
  class PinPresenter < SimpleDelegator
    def labels
      Array.new(object.binwidths(group)[index]) { |n| [object, label_for(n)] }
    end

    private

    def label_for(n)
      "#{group}(#{object.binwidths(group)[0...index].reduce(0, :+) + n})"
    end
  end
end
