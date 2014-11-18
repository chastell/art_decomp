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

    attr_reader :name
    private     :name

    private

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

    def wiring_for(src, dst, n)
      src_lab = wirings_label_for(src.object)
      dst_lab = wirings_label_for(dst.object)
      src_bin = src.object.binwidths(src.group)[0...src.index].reduce(0, :+) + n
      dst_bin = dst.object.binwidths(dst.group)[0...dst.index].reduce(0, :+) + n
      [
        "#{src_lab}_#{src.group}(#{src_bin})",
        "#{dst_lab}_#{dst.group}(#{dst_bin})",
      ]
    end

    def wirings
      wires.flat_map { |wire| wirings_for(wire.src, wire.dst) }.to_h
    end

    def wirings_for(src, dst)
      Array.new(dst.object.binwidths(dst.group)[dst.index]) do |n|
        wiring_for(src, dst, n)
      end
    end

    def wirings_label_for(object)
      case
      when object == __getobj__       then 'fsm'
      when functions.include?(object) then "f#{functions.index object}"
      when recoders.include?(object)  then "r#{recoders.index  object}"
      end
    end
  end
end
