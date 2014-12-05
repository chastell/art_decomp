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
      @wires ||= WiresPresenter.new(super, circuit_presenter: self)
    end
  end
end
