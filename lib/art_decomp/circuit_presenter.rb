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
        index = dst_puts_groups.index { |puts| puts.equal?(dst_puts) }
        index.zero? ? 'circ_outs' : "f#{index - 1}_ins"
      end

      def dst_puts
        dst_puts_groups.find { |puts| puts.include?(dst) }
      end

      def dst_puts_groups
        [circuit.own.outs] + circuit.functions.map(&:ins)
      end

      def src_offset
        src_puts[0...src_puts.index(src)].binwidth
      end

      def src_prefix
        index = src_puts_groups.index { |puts| puts.equal?(src_puts) }
        index.zero? ? 'circ_ins' : "f#{index - 1}_outs"
      end

      def src_puts
        src_puts_groups.find { |puts| puts.include?(src) }
      end

      def src_puts_groups
        [circuit.own.ins] + circuit.functions.map(&:outs)
      end
    end
  end
end
