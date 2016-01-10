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

    def line_labels
      lines.flat_map do |dst, src|
        if own.outs.include?(dst)
          dst_prefix = 'circ_outs'
          dst_puts   = own.outs
        else
          functions.find.with_index do |function, fi|
            if function.ins.include?(dst)
              dst_prefix = "f#{fi}_ins"
              dst_puts   = function.ins
            end
          end
        end
        unless dst_prefix and dst_puts
          recoders.find.with_index do |recoder, ri|
            if recoder.ins.include?(dst)
              dst_prefix = "r#{ri}_ins"
              dst_puts   = recoder.ins
            end
          end
        end
        if own.ins.include?(src)
          src_prefix = 'circ_ins'
          src_puts   = own.ins
        else
          functions.find.with_index do |function, fi|
            if function.outs.include?(src)
              src_prefix = "f#{fi}_outs"
              src_puts   = function.outs
            end
          end
        end
        unless src_prefix and src_puts
          recoders.find.with_index do |recoder, ri|
            if recoder.outs.include?(src)
              src_prefix = "r#{ri}_outs"
              src_puts   = recoder.outs
            end
          end
        end
        dst_offset = dst_puts[0...dst_puts.index(dst)].binwidth
        src_offset = src_puts[0...src_puts.index(src)].binwidth
        Array.new(dst.binwidth) do |bit|
          ["#{dst_prefix}(#{dst_offset + bit})",
           "#{src_prefix}(#{src_offset + bit})"]
        end
      end
    end

    def outs_binwidth
      own.outs.binwidth
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
            when circuit?                   then 'circ'
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
