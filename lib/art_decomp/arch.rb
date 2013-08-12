module ArtDecomp
  Arch = Struct.new :i, :o do
    def <=> other
      (i <=> other.i).nonzero? or o <=> other.o
    end

    def inspect
      "ArtDecomp::Arch[#{i},#{o}]"
    end
  end
end
