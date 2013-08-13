module ArtDecomp
  Wire = Struct.new :src, :dst do
    def inspect
      "ArtDecomp::Wire[#{src}, #{dst}]"
    end
  end
end
