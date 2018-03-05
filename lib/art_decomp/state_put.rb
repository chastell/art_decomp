require_relative 'put'

module ArtDecomp
  class StatePut < Put
    def state?
      true
    end
  end
end
