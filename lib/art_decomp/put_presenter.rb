module ArtDecomp class PutPresenter < SimpleDelegator
  DontCare = :-

  def bin_column
    Array.new(blocks.max.to_s(2).size) { |row| entry_for row }
  end

  private

  def entry_for row
    row_codes = codes { |code, block| (block & B[row]).nonzero? }.sort
    case row_codes.size
    when size then DontCare.to_s * binwidth
    when 1    then mapping_for row_codes.first
    else      raise 'trying to map multiple (but not all) codes'
    end
  end

  def mapping_for code
    codes.sort.index(code).to_s(2).rjust binwidth, '0'
  end
end end