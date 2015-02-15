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
      labels = WiresPresenter.new(super).labels
      labels.map do |(src_object, src_label), (dst_object, dst_label)|
        [
          "#{wirings_label_for(src_object)}_#{src_label}",
          "#{wirings_label_for(dst_object)}_#{dst_label}",
        ]
      end
    end

    def wirings_label_for(object)
      case
      when object == circuit          then 'fsm'
      when functions.include?(object) then "f#{functions.index(object)}"
      when recoders.include?(object)  then "r#{recoders.index(object)}"
      end
    end

    class WiresPresenter < SimpleDelegator
      def labels
        flat_map { |wire| WirePresenter.new(wire).labels }
      end
    end

    class WirePresenter < SimpleDelegator
      def labels
        src_labels = PinPresenter.new(source).labels
        dst_labels = PinPresenter.new(destination).labels
        src_labels.zip(dst_labels)
      end
    end

    class PinPresenter < SimpleDelegator
      def labels
        Array.new(object.send(group)[index].binwidth) { |n| [object, label(n)] }
      end

      private

      def label(n)
        bin = object.send(group)[0...index].map(&:binwidth).reduce(0, :+) + n
        "#{group}(#{bin})"
      end
    end
  end
end
