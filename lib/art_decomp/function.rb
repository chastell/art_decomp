module ArtDecomp class Function
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

  attr_reader :is, :os
  private     :is, :os
end end
