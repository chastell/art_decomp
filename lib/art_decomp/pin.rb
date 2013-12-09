module ArtDecomp
  Pin = Struct.new :object, :group, :index do
    def inspect
      "#{self.class}[#{object}, #{group}, #{index}]"
    end
  end
end
