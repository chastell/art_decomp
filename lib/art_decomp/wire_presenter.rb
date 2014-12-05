require 'delegate'
require_relative 'pin_presenter'

module ArtDecomp
  class WirePresenter < SimpleDelegator
    def labels
      PinPresenter.new(src).labels.zip(PinPresenter.new(dst).labels)
    end
  end
end
