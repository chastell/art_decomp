require 'delegate'

module ArtDecomp
  class PinPresenter < SimpleDelegator
    def labels
      Array.new(object.send(group)[index].binwidth) { |n| [object, label(n)] }
    end

    private

    def label(n)
      bin = object.send(group)[0...index].map(&:binwidth).reduce(0, :+) + n
      "#{group}(#{bin})"
    end
  end
end
