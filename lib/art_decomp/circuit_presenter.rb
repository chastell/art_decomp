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

    def wires
      WiresPresenter.new(super).labels(circuit)
    end

    class WiresPresenter < SimpleDelegator
      def labels(circuit)
        flat_map { |wire| WirePresenter.new(wire).labels(circuit) }
      end

      class WirePresenter < SimpleDelegator
        def labels(circuit)
          src_labels = PinPresenter.new(source).labels(circuit)
          dst_labels = PinPresenter.new(destination).labels(circuit)
          src_labels.zip(dst_labels)
        end

        class PinPresenter < SimpleDelegator
          def labels(circuit)
            Array.new(object.send(group)[index].binwidth) do |n|
              "#{prefix(circuit)}_#{label(n)}"
            end
          end

          private

          def label(n)
            bin = object.send(group)[0...index].map(&:binwidth).reduce(0, :+)
            "#{group}(#{bin + n})"
          end

          def prefix(circuit)
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
