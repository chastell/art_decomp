# frozen_string_literal: true

require 'anima'
require 'delegate'
require 'erb'
require 'forwardable'
require 'procto'
require_relative 'function_presenter'

module ArtDecomp
  # :reek:UnusedPrivateMethod: { exclude: [wire_labels] }
  class CircuitPresenter < SimpleDelegator
    include Procto.call

    def initialize(circuit, name:)
      super circuit
      @name = name
    end

    def call
      template = File.read('lib/art_decomp/circuit_presenter.vhdl.erb')
      ERB.new(template, nil, '%').result(binding)
    end

    private

    attr_reader :name

    alias circuit __getobj__

    def functions
      @functions ||= super.map(&FunctionPresenter.method(:new))
    end

    def wire_labels
      wires.flat_map do |dst, src|
        WireLabels.new(circuit: circuit, dst: dst, src: src).labels
      end
    end

    class WireLabels
      include Anima.new(:circuit, :dst, :src)

      def labels
        raise 'wire binwidths don’t match' unless dst.binwidth == src.binwidth
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
          offset = puts[0...puts.index(put)].binwidth
          Array.new(put.binwidth) { |bit| "#{prefix}_#{type}(#{offset + bit})" }
        end

        private

        def prefix
          @prefix ||= begin
            index = groups.index { |group| group.equal?(puts) }
            index.zero? ? 'circ' : "f#{index - 1}"
          end
        end

        def puts
          @puts ||= groups.find { |puts| puts.include?(put) }
        end
      end
    end
  end
end
