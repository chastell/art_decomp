module ArtDecomp class Function
  attr_reader :table

  def initialize inputs, outputs
    @table = [inputs.map(&:values), outputs.map(&:values)]
  end
end end
