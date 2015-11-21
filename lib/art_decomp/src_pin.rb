require_relative 'pin'

module ArtDecomp
  class SrcPin < Pin
    def group
      object == :circuit ? :ins : :outs
    end
  end
end
