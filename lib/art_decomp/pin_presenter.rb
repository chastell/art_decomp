require 'delegate'

module ArtDecomp
  class PinPresenter < SimpleDelegator
    def labels
      Array.new(object.send(group).binwidths[index]) { |n| [object, label(n)] }
    end

    private

    def label(n)
      "#{group}(#{object.send(group).binwidths[0...index].reduce(0, :+) + n})"
    end
  end
end
