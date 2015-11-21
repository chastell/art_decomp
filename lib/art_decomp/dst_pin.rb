require_relative 'pin'

module ArtDecomp
  class DstPin < Pin
    def group
      object == :circuit ? :outs : :ins
    end
  end
end
