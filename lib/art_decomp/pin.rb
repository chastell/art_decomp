module ArtDecomp
  Pin = Struct.new(:object, :group, :index) do
    def inspect
      "#{self.class}[#{object.inspect}, #{group.inspect}, #{index}]"
    end
  end
end
