require 'delegate'
require 'erb'
require 'forwardable'
require_relative 'function_presenter'

module ArtDecomp
  class CircuitPresenter < SimpleDelegator
    TEMPLATE_PATH = 'lib/art_decomp/circuit_presenter.vhdl.erb'

    def self.vhdl_for(circuit, name:)
      new(circuit).vhdl(name: name)
    end

    def vhdl(name:)
      @name = name
      ERB.new(File.read(self.class::TEMPLATE_PATH), nil, '%').result(binding)
    end

    private

    attr_reader :name

    alias_method :circuit, :__getobj__

    def functions
      @functions ||= super.map { |function| FunctionPresenter.new(function) }
    end

    def ins_binwidth
      own.ins.binwidth
    end

    def outs_binwidth
      own.outs.binwidth
    end

    def wire_labels
      wires.flat_map do |dst, src|
        dst_prefix, dst_puts = wire_dst(dst)
        src_prefix, src_puts = wire_src(src)
        dst_offset = dst_puts[0...dst_puts.index(dst)].binwidth
        src_offset = src_puts[0...src_puts.index(src)].binwidth
        Array.new(dst.binwidth) do |bit|
          ["#{dst_prefix}(#{dst_offset + bit})",
           "#{src_prefix}(#{src_offset + bit})"]
        end
      end
    end

    def wire_dst(dst)
      return 'circ_outs', own.outs if own.outs.include?(dst)
      functions.each.with_index do |function, fi|
        return "f#{fi}_ins", function.ins if function.ins.include?(dst)
      end
    end

    def wire_src(src)
      return 'circ_ins', own.ins if own.ins.include?(src)
      functions.each.with_index do |function, fi|
        return "f#{fi}_outs", function.outs if function.outs.include?(src)
      end
    end
  end
end
