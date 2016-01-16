require 'anima'
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
        WireLabel.new(circuit: circuit, dst: dst, src: src).labels
      end
    end

    class WireLabel
      include Anima.new(:circuit, :dst, :src)

      def labels
        Array.new(binwidth) do |bit|
          ["#{dst_prefix}(#{dst_offset + bit})",
           "#{src_prefix}(#{src_offset + bit})"]
        end
      end

      private

      def binwidth
        fail 'wire binwidths don’t match' unless dst.binwidth == src.binwidth
        dst.binwidth
      end

      def dst_offset
        dst_puts[0...dst_puts.index(dst)].binwidth
      end

      def dst_prefix
        return 'circ_outs' if circuit.own.outs.equal?(dst_puts)
        circuit.functions.map(&:ins).each.with_index do |ins, fi|
          return "f#{fi}_ins" if ins.equal?(dst_puts)
        end
      end

      def dst_puts
        return circuit.own.outs if circuit.own.outs.include?(dst)
        circuit.functions.map(&:ins).find { |ins| ins.include?(dst) }
      end

      def src_offset
        src_puts[0...src_puts.index(src)].binwidth
      end

      def src_prefix
        return 'circ_ins' if circuit.own.ins.equal?(src_puts)
        circuit.functions.map(&:outs).each.with_index do |outs, fi|
          return "f#{fi}_outs" if outs.equal?(src_puts)
        end
      end

      def src_puts
        return circuit.own.ins if circuit.own.ins.include?(src)
        circuit.functions.map(&:outs).find { |outs| outs.include?(src) }
      end
    end
  end
end
