require 'erb'

module ArtDecomp class CircuitPresenter < SimpleDelegator
  def self.vhdl_for circuit, name, circuit_presenter: new(circuit)
    circuit_presenter.vhdl name
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
    dst_lab = wirings_label_for dst.object
    src_lab = wirings_label_for src.object
    dst_bin = dst.object.binwidths(dst.group)[0...dst.index].reduce(0, :+) + n
    src_bin = src.object.binwidths(src.group)[0...src.index].reduce(0, :+) + n
    [
      "#{dst_lab}_#{dst.group}(#{dst_bin})",
      "#{src_lab}_#{src.group}(#{src_bin})",
    ]
  end

  def wirings
    Hash[wires.flat_map do |wire|
      wirings_for wire.dst, wire.src
    end]
  end

  def wirings_for dst, src
    Array.new dst.object.binwidths(dst.group)[dst.index] do |n|
      wiring_for dst, src, n
    end
  end

  def wirings_label_for object
    case
    when object.kind_of?(Circuit)   then 'fsm'
    when functions.include?(object) then "f#{functions.index object}"
    when recoders.include?(object)  then "r#{recoders.index  object}"
    end
  end
end end
