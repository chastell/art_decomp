module ArtDecomp class FunctionMerger
  def merge functions
    functions.group_by { |fun| fun.is.to_set }.map do |is, funs|
      Function.new Puts.new is: is.to_a, os: funs.flat_map(&:os).uniq
    end
  end
end end
