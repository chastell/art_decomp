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
      wires.map(&:source).select(&:circuit?).map(&:binwidth).reduce(0, :+)
    end

    def outs_binwidth
      wires.map(&:destination).select(&:circuit?).map(&:binwidth).reduce(0, :+)
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

      private

      attr_reader :circuit

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

        private

        attr_reader :circuit

        class PinPresenter < SimpleDelegator
          extend Forwardable

          def initialize(pin, circuit:)
            super pin
            @circuit = circuit
          end

          def labels
            Array.new(binwidth) { |index| "#{prefix}_#{suffix(index)}" }
          end

          private

          attr_reader :circuit

          delegate %i(functions recoders) => :circuit

          def prefix
            case
            when object == :circuit         then 'circ'
            when functions.include?(object) then "f#{functions.index(object)}"
            when recoders.include?(object)  then "r#{recoders.index(object)}"
            end
          end

          def suffix(index)
            "#{group}(#{offset + index})"
          end
        end
      end
    end
  end
end
