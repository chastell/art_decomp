module ArtDecomp class FunctionPresenter < SimpleDelegator
  DontCare = :-

  def puts
    [:is, :os]
  end

  def rows
    columns_from(is).zip columns_from os
  end

  private

  def column_from put
    Array.new(put.blocks.max.to_s(2).size) { |row| entry_for put, row }
  end

  def columns_from puts
    puts.map { |put| column_from put }.transpose.map(&:join)
  end

  def entry_for put, row
    codes = put.codes { |code, block| (block & B[row]).nonzero? }.sort
    case codes.size
    when put.size then DontCare.to_s * put.binwidth
    when 1        then put.mapping_for codes.first
    else          raise 'trying to map multiple (but not all) codes'
    end
  end
end end
