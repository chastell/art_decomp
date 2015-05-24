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

    private_attr_reader :name

    alias_method :circuit, :__getobj__

    def functions
      @functions ||= super.map { |function| FunctionPresenter.new(function) }
    end

    def ins_binwidth
      in_wires = wires.select do |wire|
        wire.source.object == :circuit and wire.source.group == :ins
      end
      in_wires.map { |wire| wire.source.binwidth }.reduce(0, :+)
    end

    def outs_binwidth
      out_wires = wires.select do |wire|
        wire.destination.object == :circuit and wire.destination.group == :outs
      end
      out_wires.map { |wire| wire.destination.binwidth }.reduce(0, :+)
    end

    def recoders
      @recoders ||= super.map { |recoder| FunctionPresenter.new(recoder) }
    end

    def wire_labels
      WiresPresenter.new(wires, circuit: circuit).labels
    end

    class WiresPresenter < SimpleDelegator
      def initialize(wires, circuit:)
        super wires
        @circuit = circuit
      end

      def labels
        flat_map { |wire| WirePresenter.new(wire, circuit: circuit).labels }
      end

      private_attr_reader :circuit

      class WirePresenter < SimpleDelegator
        def initialize(wire, circuit:)
          super wire
          @circuit = circuit
        end

        def labels
          src_labels = PinPresenter.new(source, circuit: circuit).labels
          dst_labels = PinPresenter.new(destination, circuit: circuit).labels
          src_labels.zip(dst_labels)
        end

        private_attr_reader :circuit

        class PinPresenter < SimpleDelegator
          extend Forwardable

          def initialize(pin, circuit:)
            super pin
            @circuit = circuit
          end

          def labels
            Array.new(binwidth) { |n| "#{prefix}_#{suffix(n)}" }
          end

          private

          private_attr_reader :circuit

          delegate %i(functions recoders) => :circuit

          def prefix
            case
            when object == :circuit         then 'circ'
            when functions.include?(object) then "f#{functions.index(object)}"
            when recoders.include?(object)  then "r#{recoders.index(object)}"
            end
          end

          def suffix(n)
            "#{group}(#{offset + n})"
          end
        end
      end
    end
  end
end
