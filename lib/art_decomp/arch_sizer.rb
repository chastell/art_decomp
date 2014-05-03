require 'delegate'
require_relative 'arch'

module ArtDecomp class ArchSizer < SimpleDelegator
  def fits?
    i <= 8
  end

  def max_quarters
    case
    when i.zero?, o.zero? then 0
    when i <= 5           then (o / 2.0).ceil
    when i == 6           then o
    when i == 7           then o * 2
    when i == 8           then o * 4
    else
      o * (1 + 4 * self.class.new(Arch[i - 2, 1]).max_quarters)
    end
  end

  def min_quarters
    case
    when i.zero?, o.zero? then 0
    when i <= 5           then (o / 2.0).ceil
    else [(i / 5.0).ceil, (o / 2.0).ceil].max
    end
  end
end end
