module ArtDecomp class FunctionSimplifier
  def simplify function
    os   = function.os
    seps = os.map(&:seps).reduce :|
    is   = function.is.sort_by { |i| (i.seps & seps).size }.reverse
    Function.new take_required(is, seps), os
  end

  private

  def take_required is, seps
    is.take_while do |i|
      empty = seps.empty?
      seps -= i.seps
      not empty
    end
  end
end end
