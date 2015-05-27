require 'delegate'
require_relative 'put_presenter'

module ArtDecomp
  class PutsPresenter < SimpleDelegator
    def bin_columns
      map { |put| PutPresenter.new(put).bin_column }.transpose.map(&:join)
    end

    def simple
      map(&:column).transpose.map { |code| code.join(' ') }
    end
  end
end
