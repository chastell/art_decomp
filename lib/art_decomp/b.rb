module ArtDecomp module B
  def self.[] *bits
    bits.reduce(0) { |int, bit| int | 1 << bit }
  end
end end
