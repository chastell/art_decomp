require 'delegate'

module ArtDecomp class FunctionPresenter < SimpleDelegator
  DontCare = :-

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
    when put.size then DontCare.to_s * put.width
    when 1        then mapping_for put, codes.first
    else          raise 'trying to map multiple (but not all) codes'
    end
  end

  def mapping_for put, code
    put.codes.sort.index(code).to_s(2).rjust put.width, '0'
  end
end end
