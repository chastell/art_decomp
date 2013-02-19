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
    all     = put.keys.sort
    width   = Math.log2(all.size).ceil
    mapping = Hash[all.map.with_index do |key, index|
      [key, index.to_s(2).rjust(width, '0')]
    end]
    dont_care = DontCare.to_s * width
    Array.new(put.values.flatten.max + 1) do |row|
      keys = put.select { |code, rows| rows.include? row }.keys.sort
      case
      when keys == all    then dont_care
      when keys.size == 1 then mapping[keys.first]
      else                raise 'trying to map multiple (but not all) keys'
      end
    end
  end
end end
