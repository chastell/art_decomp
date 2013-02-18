module ArtDecomp class FunctionPresenter
  def initialize function
    @function = function
  end

  def widths group
    function.widths group
  end

  attr_reader :function
  private     :function
end end
