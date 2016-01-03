require_relative 'pin'

module ArtDecomp
  class SrcPin < Pin
    def group
      circuit? ? :ins : :outs
    end
  end
end
