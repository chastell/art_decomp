module ArtDecomp class FunctionSimplifier
  def simplify function
    os   = function.puts.os
    seps = os.map(&:seps).reduce :|
    is   = function.puts.is.sort_by { |i| (i.seps & seps).size }.reverse
    Function.new Puts.new is: take_required(is, seps), os: os
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
