module ArtDecomp
  Pin = Struct.new :object, :group, :index do
    def inspect
      "ArtDecomp::Pin[#{object}, #{group}, #{index}]"
    end
  end
end
