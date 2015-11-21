require 'delegate'

module ArtDecomp
  class PutPresenter < SimpleDelegator
    def bin_column
      column.map { |code| mapping[code] }
    end

    private

    def mapping
      @mapping ||= begin
        encodings = Array.new(codes.size) { |i| i.to_s(2).rjust(binwidth, '0') }
        codes.sort.zip(encodings).to_h.merge(:- => '-' * binwidth)
      end
    end
  end
end
