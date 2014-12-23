require_relative 'pin'

module ArtDecomp
  Wire = Struct.new(:source, :destination) do
    def self.from_arrays(source, destination)
      new(Pin[*source], Pin[*destination])
    end

    def inspect
      "#{self.class}[#{source}, #{destination}]"
    end
  end
end
