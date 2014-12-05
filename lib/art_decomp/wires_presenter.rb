require 'delegate'
require_relative 'wire_presenter'

module ArtDecomp
  class WiresPresenter < SimpleDelegator
    def labels
      flat_map do |wire|
        WirePresenter.new(wire).labels.map do |src_label, dst_label|
          [
            [wire.src.object, src_label],
            [wire.dst.object, dst_label],
          ]
        end
      end
    end
  end
end
