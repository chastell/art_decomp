module ArtDecomp class FunctionPresenter
  DontCare = :-

  def initialize function
    @function = function
  end

  def rows
    ins  = function.is.map { |i| column_from i }.transpose.map(&:join)
    outs = function.os.map { |o| column_from o }.transpose.map(&:join)
    ins.zip outs
  end

  def widths group
    function.widths group
  end

  attr_reader :function
  private     :function

  private

  def column_from put
    dont_care = DontCare.to_s * width_of(put)
    Array.new(put.values.flatten.max + 1) do |row|
      entry_for put, row, dont_care
    end
  end

  def entry_for put, row, dont_care
    mapping = mapping_for put
    keys = put.select { |code, rows| rows.include? row }.keys.sort
    case
    when keys == put.keys.sort then dont_care
    when keys.size == 1        then mapping[keys.first]
    else                       raise 'trying to map multiple (but not all) keys'
    end
  end

  def mapping_for put
    Hash[put.keys.sort.map.with_index do |key, index|
      [key, index.to_s(2).rjust(width_of(put), '0')]
    end]
  end

  def width_of put
    Math.log2(put.size).ceil
  end
end end
