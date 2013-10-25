module ArtDecomp class FunctionSimplifier < SimpleDelegator
  def self.simplify function
    new(function).simplify
  end

  def simplify
    seps = os.map(&:seps).reduce :|
    is   = self.is.sort_by { |i| (i.seps & seps).size }.reverse
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
