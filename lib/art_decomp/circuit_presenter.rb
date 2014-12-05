require 'delegate'
require 'erb'
require_relative 'function_presenter'
require_relative 'wires_presenter'

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

    attr_reader :name
    private     :name

    private

    alias_method :circuit, :__getobj__

    def functions
      @functions ||= super.map { |function| FunctionPresenter.new(function) }
    end

    def fsm_is_binwidth
      binwidths(:is).reduce(0, :+)
    end

    def fsm_os_binwidth
      binwidths(:os).reduce(0, :+)
    end

    def fsm_qs_binwidth
      binwidths(:qs).reduce(0, :+)
    end

    def recoders
      @recoders ||= super.map { |recoder| FunctionPresenter.new(recoder) }
    end

    def reset_bits
      '0' * fsm_qs_binwidth
    end

    def wires
      labels = WiresPresenter.new(super).labels
      labels.map do |(src_obj, src_lab), (dst_obj, dst_lab)|
        [
          "#{wirings_label_for(src_obj)}_#{src_lab}",
          "#{wirings_label_for(dst_obj)}_#{dst_lab}",
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
  end
end
