require 'delegate'
require_relative 'b'

module ArtDecomp
  class PutPresenter < SimpleDelegator
    def bin_column
      column.map { |code| code == :- ? '-' * binwidth : mapping_for(code) }
    end

    private

    def mapping_for(code)
      codes.sort.index(code).to_s(2).rjust(binwidth, '0')
    end
  end
end
