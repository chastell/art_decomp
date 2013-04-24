module ArtDecomp class FunctionPresenter
  DontCare = :-

  def initialize function
    @function = function
  end

  def rows
    columns_from(function.is).zip columns_from function.os
  end

  def widths group
    function.widths group
  end

  attr_reader :function
  private     :function

  private

  def column_from put
    dont_care = DontCare.to_s * ArtDecomp.width_of(put)
    Array.new(put.values.max.to_s(2).size) do |row|
      entry_for put, row, dont_care
    end
  end

  def columns_from puts
    puts.map { |s| column_from s }.transpose.map(&:join)
  end

  def entry_for put, row, dont_care
    mapping = mapping_for put
    keys = put.select { |code, bits| (bits & 1 << row).nonzero? }.keys.sort
    case
    when keys == put.keys.sort then dont_care
    when keys.size == 1        then mapping[keys.first]
    else                       raise 'trying to map multiple (but not all) keys'
    end
  end

  def mapping_for put
    Hash[put.keys.sort.map.with_index do |key, index|
      [key, index.to_s(2).rjust(ArtDecomp.width_of(put), '0')]
    end]
  end
end end
