# frozen_string_literal: true

module ArtDecomp
  # :reek:UncommunicativeModuleName
  module B
    module_function

    def [](*bits)
      bits.reduce(0) { |int, bit| int | 1 << bit }
    end
  end
end
