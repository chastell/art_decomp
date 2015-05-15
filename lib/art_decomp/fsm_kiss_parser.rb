require_relative 'kiss_parser'

module ArtDecomp
  class FSMKISSParser < KISSParser
    def circuit
      FSM.from_puts(puts)
    end
  end
end
