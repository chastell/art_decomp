require 'delegate'
require 'erb'
require_relative 'function_presenter'

module ArtDecomp
  class CircuitPresenter < SimpleDelegator
    def self.vhdl_for(circuit, name:)
      new(circuit).vhdl(name: name)
    end

    def vhdl(name:)
      @name    = name
      template = File.read('lib/art_decomp/circuit_presenter.vhdl.erb')
      ERB.new(template, nil, '%').result(binding)
    end

    private_attr_reader :name

    private

    alias_method :circuit, :__getobj__

    def functions
      @functions ||= super.map { |function| FunctionPresenter.new(function) }
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
          def initialize(pin, circuit:)
            super pin
            @circuit = circuit
          end

          def labels
            Array.new(object.send(group)[index].binwidth) do |n|
              "#{prefix}_#{label(n)}"
            end
          end

          private_attr_reader :circuit

          private

          def label(n)
            bin = object.send(group)[0...index].map(&:binwidth).reduce(0, :+)
            "#{group}(#{bin + n})"
          end

          def prefix
            functions, recoders = circuit.functions, circuit.recoders
            case
            when object == circuit          then 'fsm'
            when functions.include?(object) then "f#{functions.index(object)}"
            when recoders.include?(object)  then "r#{recoders.index(object)}"
            end
          end
        end
      end
    end
  end
end
