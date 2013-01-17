module ArtDecomp class Function
  attr_reader :encodings, :table

  def initialize inputs, outputs
    @encodings = [inputs.map(&:keys),   outputs.map(&:keys)  ]
    @table     = [inputs.map(&:values), outputs.map(&:values)]
  end
end end
