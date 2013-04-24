require 'delegate'

module ArtDecomp class FunctionPresenter < SimpleDelegator
  DontCare = :-

  def rows
    columns_from(is).zip columns_from os
  end

  private

  def column_from put
    Array.new(put.values.max.to_s(2).size) { |row| entry_for put, row }
  end

  def columns_from puts
    puts.map { |put| column_from put }.transpose.map(&:join)
  end

  def entry_for put, row
    keys = put.select { |code, bits| (bits & 1 << row).nonzero? }.keys.sort
    case keys.size
    when put.size then DontCare.to_s * ArtDecomp.width_of(put)
    when 1        then mapping_for put, keys.first
    else          raise 'trying to map multiple (but not all) keys'
    end
  end

  def mapping_for put, key
    put.keys.sort.index(key).to_s(2).rjust ArtDecomp.width_of(put), '0'
  end
end end
