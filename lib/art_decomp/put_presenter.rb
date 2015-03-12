require 'delegate'
require_relative 'b'

module ArtDecomp
  class PutPresenter < SimpleDelegator
    def bin_column
      column.map do |code|
        if code == :-
          '-' * binwidth
        else
          codes.sort.index(code).to_s(2).rjust(binwidth, '0')
        end
      end
    end
  end
end
