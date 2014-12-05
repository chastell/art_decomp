require 'delegate'

module ArtDecomp
  class WirePresenter < SimpleDelegator
    def wirings
      Array.new(dst.object.binwidths(dst.group)[dst.index]) do |n|
        wiring_for(n)
      end
    end

    private

    def wiring_for(n)
      src_bin = src.object.binwidths(src.group)[0...src.index].reduce(0, :+) + n
      dst_bin = dst.object.binwidths(dst.group)[0...dst.index].reduce(0, :+) + n
      [
        [src.object, "#{src.group}(#{src_bin})"],
        [dst.object, "#{dst.group}(#{dst_bin})"],
      ]
    end
  end
end
