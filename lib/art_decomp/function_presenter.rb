require 'delegate'
require_relative 'puts_presenter'

module ArtDecomp
  class FunctionPresenter < SimpleDelegator
    def rows
      is_cols = PutsPresenter.new(is).bin_columns
      os_cols = PutsPresenter.new(os).bin_columns
      is_cols.zip(os_cols)
    end
  end
end
