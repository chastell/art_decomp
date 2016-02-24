# frozen_string_literal: true

require 'delegate'
require_relative 'function'
require_relative 'puts_presenter'

module ArtDecomp
  class FunctionPresenter < DelegateClass(Function)
    def simple
      ins_cols  = PutsPresenter.new(ins).simple
      outs_cols = PutsPresenter.new(outs).simple
      rows = ins_cols.zip(outs_cols).map { |row_parts| row_parts.join(' | ') }
      rows.join("\n") + "\n"
    end

    def rows
      ins_cols  = PutsPresenter.new(ins).bin_columns
      outs_cols = PutsPresenter.new(outs).bin_columns
      ins_cols.zip(outs_cols)
    end
  end
end
