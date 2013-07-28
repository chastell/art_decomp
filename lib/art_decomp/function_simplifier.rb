module ArtDecomp class FunctionSimplifier
  def simplify function, function_factory: Function
    seps = function.os.map(&:seps).inject :+
    is   = function.is.sort_by { |i| (i.seps & seps).size }.reverse
    is   = is.take_while do |i|
      empty = seps.empty?
      seps -= i.seps
      not empty
    end
    function_factory.new is, function.os
  end
end end
