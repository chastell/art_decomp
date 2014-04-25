module ArtDecomp class FunctionPresenter < SimpleDelegator
  def rows
    is_cols = PutGroupPresenter.new(is).bin_columns
    os_cols = PutGroupPresenter.new(os).bin_columns
    is_cols.zip os_cols
  end

  class PutPresenter < SimpleDelegator
    def bin_column
      Array.new(blocks.max.to_s(2).size) { |row| entry_for row }
    end

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
  end

  class PutGroupPresenter < SimpleDelegator
    def bin_columns
      map { |put| PutPresenter.new(put).bin_column }.transpose.map(&:join)
    end
  end
end end
