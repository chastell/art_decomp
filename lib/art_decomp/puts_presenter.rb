require 'delegate'

module ArtDecomp
  class PutsPresenter < SimpleDelegator
    def bin_columns
      map(&PutPresenter.method(:new)).map(&:bin_column).transpose.map(&:join)
    end

    def simple
      map(&:column).transpose.map { |code| code.join(' ') }
    end

    class PutPresenter < SimpleDelegator
      def bin_column
        column.map { |code| mapping[code] }
      end

      private

      def mapping
        @mapping ||= begin
          bin = Array.new(codes.size) { |int| int.to_s(2).rjust(binwidth, '0') }
          codes.sort.zip(bin).to_h.merge(:- => '-' * binwidth)
        end
      end
    end
  end
end
