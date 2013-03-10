module ArtDecomp class Function
  attr_reader :is, :os

  def initialize is, os
    @is = is
    @os = os
  end

  def encodings
    [is.map(&:keys), os.map(&:keys)]
  end

  def table
    [is.map(&:values), os.map(&:values)]
  end

  def widths group
    ss = { i: is, o: os }[group]
    ss.map { |s| width_of s }
  end
end end
