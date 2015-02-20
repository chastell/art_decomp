require 'delegate'
require_relative 'puts_presenter'

module ArtDecomp
  class FunctionPresenter < SimpleDelegator
    def rows
      ins_cols  = PutsPresenter.new(ins).bin_columns
      outs_cols = PutsPresenter.new(outs).bin_columns
      ins_cols.zip(outs_cols)
    end
  end
end
