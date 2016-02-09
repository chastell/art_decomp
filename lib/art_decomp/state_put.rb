# frozen_string_literal: true

require_relative 'put'

module ArtDecomp
  class StatePut < Put
    def state?
      true
    end
  end
end
