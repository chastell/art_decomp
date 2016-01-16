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
        fins  = circuit.functions.map(&:ins)
        index = (0...fins.size).find { |fi| fins[fi].equal?(dst_puts) }
        "f#{index}_ins"
      end

      def dst_puts
        puts_groups = [circuit.own.outs] + circuit.functions.map(&:ins)
        puts_groups.find { |puts| puts.include?(dst) }
      end

      def src_offset
        src_puts[0...src_puts.index(src)].binwidth
      end

      def src_prefix
        return 'circ_ins' if circuit.own.ins.equal?(src_puts)
        fouts = circuit.functions.map(&:outs)
        index = (0...fouts.size).find { |fi| fouts[fi].equal?(src_puts) }
        "f#{index}_outs"
      end

      def src_puts
        put_groups = [circuit.own.ins] + circuit.functions.map(&:outs)
        put_groups.find { |puts| puts.include?(src) }
      end
    end
  end
end
