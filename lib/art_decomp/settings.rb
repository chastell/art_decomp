require 'optparse'

module ArtDecomp
  Settings = Struct.new :kiss_path, :vhdl_path do
    def initialize(args)
      OptionParser.new do |opts|
        opts.on('--dir=DIR', String) { |dir| self.vhdl_path = dir }
      end.parse! args
      self.kiss_path = args.first
    end
  end
end
