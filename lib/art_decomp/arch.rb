module ArtDecomp
  Arch = Struct.new :i, :o do
    def <=> other
      (i <=> other.i).nonzero? or o <=> other.o
    end
  end
end
