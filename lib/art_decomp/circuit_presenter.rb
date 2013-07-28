require 'erb'

module ArtDecomp class CircuitPresenter < SimpleDelegator
  def self.vhdl_for circuit, name, circuit_presenter: new(circuit)
    circuit_presenter.vhdl name
  end

  def puts
    [:is, :os, :ps, :qs]
  end

  def vhdl name
    template = File.read 'lib/art_decomp/circuit_presenter.vhdl.erb'
    ERB.new(template, nil, '%').result binding
  end

  private

  def functions
    @functions ||= super.map { |function| FunctionPresenter.new function }
  end

  def fsm_is_binwidth
    binwidths(:is).reduce 0, :+
  end

  def fsm_os_binwidth
    binwidths(:os).reduce 0, :+
  end

  def fsm_qs_binwidth
    binwidths(:qs).reduce 0, :+
  end

  def recoders
    @recoders ||= super.map { |recoder| FunctionPresenter.new recoder }
  end

  def reset_bits
    '0' * fsm_qs_binwidth
  end

  def wiring_for dst, src, n
    dst_bin = dst.object.binwidths(dst.group)[0...dst.index].reduce(0, :+) + n
    src_bin = src.object.binwidths(src.group)[0...src.index].reduce(0, :+) + n
    [
      "#{dst.label}_#{dst.group}(#{dst_bin})",
      "#{src.label}_#{src.group}(#{src_bin})",
    ]
  end

  def wirings
    Hash[wires.flat_map do |wire|
      dst = wirings_pin_for wire.dst
      src = wirings_pin_for wire.src
      wirings_for dst, src
    end]
  end

  def wirings_for dst, src
    Array.new dst.object.binwidths(dst.group)[dst.index] do |n|
      wiring_for dst, src, n
    end
  end

  def wirings_label_for object
    case
    when object == self             then 'fsm'
    when functions.include?(object) then "f#{functions.index object}"
    when recoders.include?(object)  then "r#{recoders.index  object}"
    end
  end

  def wirings_pin_for pin
    pin.label = wirings_label_for pin.object
    pin
  end
end end
