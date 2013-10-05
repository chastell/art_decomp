module ArtDecomp class FunctionPresenter < SimpleDelegator
  def puts
    [:is, :os]
  end

  def rows
    columns_from(is).zip columns_from os
  end

  private

  def columns_from puts
    puts.map { |put| PutPresenter.new(put).bin_column }.transpose.map(&:join)
  end
end end
