module ArtDecomp
  Wire = Struct.new(:src, :dst) do
    def inspect
      "#{self.class}[#{src}, #{dst}]"
    end
  end
end
