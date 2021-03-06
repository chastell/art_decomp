require 'delegate'
require_relative 'arch'

module ArtDecomp
  class ArchSizer < DelegateClass(Arch)
    def fits?
      i <= 8
    end

    # :reek:TooManyStatements: { max_statements: 6 }
    def max_quarters                           # rubocop:disable Metrics/AbcSize
      case
      when i.zero?, o.zero? then 0
      when i <= 5           then (o / 2.0).ceil
      when i == 6           then o
      when i == 7           then o * 2
      when i == 8           then o * 4
      else o * (1 + 4 * self.class.new(Arch[i - 2, 1]).max_quarters)
      end
    end

    def min_quarters                           # rubocop:disable Metrics/AbcSize
      case
      when i.zero?, o.zero? then 0
      when i <= 5           then (o / 2.0).ceil
      else [(i / 5.0).ceil, (o / 2.0).ceil].max
      end
    end
  end
end
