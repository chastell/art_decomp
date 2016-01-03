require_relative 'pin'

module ArtDecomp
  class DstPin < Pin
    def group
      circuit? ? :outs : :ins
    end
  end
end
