require_relative '../spec_helper'

module ArtDecomp describe CircuitSizer do
  describe '#min_size' do
    it 'returns the smallest possible size for the given Circuit' do
      {
        []                                => 0,
        [Arch[0,0]]                       => 0,
        [Arch[0,1]]                       => 0,
        [Arch[1,0]]                       => 0,
        [Arch[1,1]]                       => 1,
        [Arch[5,2]]                       => 1,
        [Arch[5,3], Arch[5,3], Arch[5,1]] => 2,
        [Arch[7,0]]                       => 0,
        [Arch[20,8]]                      => 1,
        [Arch[21,8]]                      => 2,
        [Arch[20,9]]                      => 2,
      }.each do |archs, size|
        functions = archs.map { |arch| fake :function, arch: arch }
        circuit   = fake :circuit, :functions => functions
        CircuitSizer.new(circuit).min_size.must_equal size
      end
    end
  end
end end
