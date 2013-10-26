module ArtDecomp class FunctionMerger
  def merge functions
    functions.group_by(&:is).map do |is, funs|
      Function.new Puts.new is: is, os: funs.flat_map(&:os).uniq
    end
  end
end end
