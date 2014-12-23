require 'delegate'
require_relative 'pin_presenter'

module ArtDecomp
  class WirePresenter < SimpleDelegator
    def labels
      PinPresenter.new(source).labels.zip(PinPresenter.new(destination).labels)
    end
  end
end
