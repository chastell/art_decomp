require 'delegate'
require_relative 'function_presenter/put_group_presenter'

module ArtDecomp class FunctionPresenter < SimpleDelegator
  def rows
    is_cols = PutGroupPresenter.new(is).bin_columns
    os_cols = PutGroupPresenter.new(os).bin_columns
    is_cols.zip os_cols
  end
end end
