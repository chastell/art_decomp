require 'delegate'
require_relative 'b'

module ArtDecomp class PutPresenter < SimpleDelegator
  def bin_column
    Array.new(blocks.max.to_s(2).size) { |row| entry_for row }
  end

  private

  def entry_for row
    row_codes = codes { |_, block| (block & B[row]).nonzero? }.sort
    case row_codes.size
    when size then '-' * binwidth
    when 1    then mapping_for row_codes.first
    else fail 'trying to map multiple (but not all) codes'
    end
  end

  def mapping_for code
    codes.sort.index(code).to_s(2).rjust binwidth, '0'
  end
end end
