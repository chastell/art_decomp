require 'delegate'
require_relative 'wire_presenter'

module ArtDecomp
  class WiresPresenter < SimpleDelegator
    def labels
      flat_map { |wire| WirePresenter.new(wire).labels }
    end
  end
end
