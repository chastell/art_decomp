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
        fail 'wire binwidths don’t match' unless dst.binwidth == src.binwidth
        dst_labels.zip(src_labels)
      end

      private

      def dst_labels
        groups = [circuit.own.outs] + circuit.functions.map(&:ins)
        PutLabels.new(groups: groups, put: dst, type: :dst).labels
      end

      def src_labels
        groups = [circuit.own.ins] + circuit.functions.map(&:outs)
        PutLabels.new(groups: groups, put: src, type: :src).labels
      end

      class PutLabels
        include Anima.new(:groups, :put, :type)

        def labels
          Array.new(put.binwidth) { |bit| "#{prefix}(#{offset + bit})" }
        end

        private

        def offset
          puts[0...puts.index(put)].binwidth
        end

        def prefix
          index = groups.index { |group| group.equal?(puts) }
          ctype = type == :dst ? :dst : :src
          ftype = type == :dst ? :dst : :src
          index.zero? ? "circ_#{ctype}" : "f#{index - 1}_#{ftype}"
        end

        def puts
          groups.find { |puts| puts.include?(put) }
        end
      end
    end
  end
end
