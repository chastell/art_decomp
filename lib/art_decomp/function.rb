module ArtDecomp class Function
  def initialize inputs, outputs
    @inputs  = inputs
    @outputs = outputs
  end

  def encodings
    [inputs.map(&:keys), outputs.map(&:keys)]
  end

  def table
    [inputs.map(&:values), outputs.map(&:values)]
  end

  attr_reader :inputs, :outputs
  private     :inputs, :outputs
end end
