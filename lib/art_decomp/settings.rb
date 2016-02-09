# frozen_string_literal: true

require 'anima'
require 'optparse'

module ArtDecomp
  class Settings
    include Anima.new(:kiss_path, :vhdl_path)

    def initialize(args)
      OptionParser.new do |opts|
        opts.on('--dir=DIR', String) { |dir| @vhdl_path = dir }
      end.parse! args
      @kiss_path = args.first
    end
  end
end
