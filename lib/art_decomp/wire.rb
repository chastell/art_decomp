require_relative 'pin'

module ArtDecomp
  Wire = Struct.new(:src, :dst) do
    def self.from_arrays(source, destination)
      new(Pin[*source], Pin[*destination])
    end

    def inspect
      "#{self.class}[#{src}, #{dst}]"
    end
  end
end
